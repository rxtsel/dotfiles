"""Initialize the calibrated Fifine input without depending on PipeWire node IDs."""

import configparser
import json
import os
from pathlib import Path
import subprocess
import sys
import time


def prepare(config_path, source):
    """Pin only the physical input; preserve other EasyEffects preferences."""
    path = Path(config_path)
    settings = configparser.ConfigParser(interpolation=None, delimiters=("=",), strict=False)
    settings.optionxform = str
    settings.read(path)
    if not settings.has_section("StreamInputs"):
        settings.add_section("StreamInputs")
    settings["StreamInputs"]["inputDevice"] = source
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w") as output:
        settings.write(output, space_around_delimiters=False)


def find_node(objects, name):
    return next(
        (
            obj["id"]
            for obj in objects
            if obj.get("type", "").endswith(":Node")
            and obj.get("info", {}).get("props", {}).get("node.name") == name
        ),
        None,
    )


def activate(environment):
    deadline = time.monotonic() + 15
    while time.monotonic() < deadline:
        result = subprocess.run(
            [environment["FIFINE_PW_DUMP"]], capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            objects = json.loads(result.stdout)
            virtual = find_node(objects, "easyeffects_source")
            if virtual is not None:
                # The virtual node can appear before the single-instance CLI is ready.
                time.sleep(1)
                physical = find_node(objects, environment["FIFINE_SOURCE"])
                if physical is not None:
                    subprocess.run(
                        [environment["FIFINE_WPCTL"], "set-volume", str(physical), "0.94"],
                        check=True, timeout=5,
                    )
                subprocess.run(
                    [environment["FIFINE_EASYEFFECTS"], "--load-preset", environment["FIFINE_PRESET"]],
                    check=True, timeout=10,
                )
                subprocess.run(
                    [environment["FIFINE_WPCTL"], "set-default", str(virtual)],
                    check=True, timeout=5,
                )
                return
        time.sleep(0.25)
    raise RuntimeError("Easy Effects Source did not become available")


def main():
    if sys.argv[1:] == ["prepare"]:
        prepare(os.environ["FIFINE_CONFIG"], os.environ["FIFINE_SOURCE"])
    elif sys.argv[1:] == ["activate"]:
        activate(os.environ)
    else:
        raise SystemExit("Usage: fifine-init.py prepare|activate")


if __name__ == "__main__":
    main()
