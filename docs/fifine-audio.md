# Fifine K688: system-wide noise reduction

## Approved setup

The input preset is named `with_fifine_60pct_fisic_8-12cm`.

| Setting | Calibrated value |
| --- | --- |
| Connection | USB |
| Physical microphone gain knob | Approximately 60% |
| Mouth distance | 8–12 cm from the end of the microphone, not its side |
| PipeWire physical input volume | 94% |
| Application input | Easy Effects Source |
| Noise reduction | RNNoise, standard model |
| RNNoise input/output gain | 0 dB / 0 dB |
| RNNoise wet level | 0 dB |
| Voice activity detection (VAD) | Disabled |
| Release setting | 100 ms (VAD disabled) |
| Additional gate, compressor, or equalizer | None |

The physical knob cannot be set by software. Restore it manually whenever using
this preset. The preset name documents the required physical setup; it does not
control the knob.

## What was tested

Calibration used `pw-record` at 48 kHz, mono, signed 16-bit PCM. Audio was analyzed
in memory, without saving recordings or uploading them to an external service.
The environment included concerns about rain on a metal roof and barking dogs;
we did not establish that those particular noises occurred during the measurements.

Original and processed audio were captured simultaneously. EasyEffects initially
redirected both measurement streams to its processed source. Adding the original
measurement node (`fifine_calibration_original`) to the input blocklist fixed that.
PipeWire links were then inspected to verify separate raw and filtered inputs.

| Measurement | Original | RNNoise |
| --- | --- | --- |
| Initial ambient RMS | −57.3 dBFS | −71.3 dBFS |
| Speech interval RMS | −34.9 dBFS | −35.2 dBFS |
| Speech interval peak | −17.1 dBFS | −16.3 dBFS |
| Near-clipping samples | 0 | 0 |

This represents approximately 14 dB of ambient attenuation in that interval, with
only 0.3 dB difference in average speech level. These are interval measurements,
not a guarantee of equivalent performance for other noises or rooms.

A live listening test was approved by the user: the voice sounded good and ambient
noise was not audible. No additional processing was added after approval.

## Declarative configuration

- `modules/home/services/fifine-audio.nix`: Home Manager module `fifineAudio`.
- `modules/hosts/blackout/default.nix`: enables the module only on `blackout`.
- `assets/audio/with_fifine_60pct_fisic_8-12cm.json`: versioned input preset.
- `assets/audio/fifine-init.py`: startup preparation and dynamic node lookup.

Home Manager installs EasyEffects and links the JSON into
`~/.local/share/easyeffects/input/` (the EasyEffects 8 preset location).
The user service `fifine-clean-audio.service`:

1. Selects the physical USB Fifine in EasyEffects preferences while preserving
   other preference values.
2. Starts EasyEffects in service mode with the graphical session.
3. Waits for the virtual source to appear before invoking the preset-loading CLI.
   Invoking that CLI immediately at process launch caused a startup race during
   testing, so readiness handling is intentional.
4. Restores the physical source's software volume to 94% when it is present.
5. Loads the approved input preset and makes Easy Effects Source the default input.

Node IDs are discovered by name, never hard-coded. Applications following the
default input use the processed source. Applications explicitly pinned to the
physical Fifine must select **Easy Effects Source** once. EasyEffects can also
redirect application streams automatically; OBS was observed using the processed
source during testing.

The service does not start live monitoring and does not change output volume.
Do not enable another EasyEffects service or desktop autostart entry alongside it.
After unplugging/reconnecting the microphone, restart the service if the input or
calibrated software volume is not restored:

```bash
systemctl --user restart fifine-clean-audio.service
```

## Migrating the initial manual setup

The working setup was initially installed with `nix profile add nixpkgs#easyeffects`
and a manually written user unit. Repository changes do not automatically apply
that system configuration. Keep the working service until the declarative build
has been reviewed and built successfully.

The repository configuration differs from the older `/etc/nixos` tree. Switching
this flake may apply unrelated system changes: review the complete configuration
before switching.

Build from the repository, including new untracked files:

```bash
cd ~/dotfiles
nixos-rebuild build --flake path:.#blackout
```

Before the first switch, back up the two manually created files that Home Manager
will own. Use a new backup directory rather than overwriting existing backups:

```bash
backup="$(mktemp -d "$HOME/fifine-before-home-manager.XXXXXX")"
systemctl --user disable --now fifine-clean-audio.service
mv ~/.config/systemd/user/fifine-clean-audio.service "$backup/"
mv ~/.local/share/easyeffects/input/with_fifine_60pct_fisic_8-12cm.json "$backup/"
sudo nixos-rebuild switch --flake path:.#blackout
systemctl --user daemon-reload
systemctl --user start fifine-clean-audio.service
```

Noise reduction is briefly unavailable between stopping the old service and
starting the declarative one. If the switch fails, restore those two files from
the backup, run `systemctl --user daemon-reload`, and re-enable the old service.

After a successful switch and verification, remove the redundant profile package:

```bash
nix profile remove easyeffects
```

The old `~/.local/bin/fifine-set-default.py` and
`~/.local/share/easyeffects/README-fifine.md` can then be removed; the declarative
unit uses the versioned script in the Nix store instead. The trial preset
`Fifine-K688-Prueba.json` is not needed after the approved preset is deployed.
The temporary `Fifine-Escucha-Directa` output preset is optional and is not installed
by the declarative module.

## Verification and manual preset selection

```bash
systemctl --user is-enabled fifine-clean-audio.service
systemctl --user status fifine-clean-audio.service
easyeffects --last-loaded-preset input
wpctl status -n
journalctl --user -u fifine-clean-audio.service -b
```

Expected results: the service is enabled and active, the approved preset is loaded,
and `easyeffects_source` is the default audio source. Verify the physical Fifine's
volume using its current node ID from `wpctl status`, not an ID from this session.

To reload the approved preset without restarting:

```bash
easyeffects --load-preset with_fifine_60pct_fisic_8-12cm
```

## Creating more profiles

1. Create a separate input preset in EasyEffects instead of overwriting the
   approved baseline.
2. Include physical gain and distance in its name when those conditions differ.
3. Copy its exported JSON into `assets/audio/` and add an `xdg.dataFile` entry in
   `fifine-audio.nix` for the new preset.
4. Keep calibration and listening notes in this document or a separate document.
5. Change the module's `preset` value if the new profile should load at login.

Home Manager owns the deployed baseline as a read-only Nix store symlink. Edit its
versioned source and rebuild to change it; use a different preset name for GUI
experiments. Selecting another preset during a session is supported, but restarting
the service loads the configured baseline again.

## Listening through headphones

The Fifine headphone jack can provide direct hardware monitoring, which bypasses
PipeWire and RNNoise. Hearing room noise there does not mean applications receive
unfiltered audio.

The approved processed listening test used headphones connected to the tower's
rear green analog output. Output volume was lowered from 100% to 25% as a safety
precaution; that was a test setting, not part of the microphone preset.

The first monitoring attempt was diverted by EasyEffects into its virtual output
sink and was not heard. Excluding the playback node `fifine_listen_playback` in an
output preset allowed a verified direct route:

```text
Fifine USB -> RNNoise -> Easy Effects Source
    -> temporary pw-loopback -> physical tower output -> headphones
```

Monitoring was time-limited and is not enabled at login. A small playback delay is
normal. Use headphones, not speakers, to avoid feedback. Never infer audible
success from an active PipeWire link alone: verify it by listening.

## Disabling processing

For a temporary stop:

```bash
systemctl --user stop fifine-clean-audio.service
```

Then select the physical Fifine as the input in the audio settings. For permanent
removal, remove `fifineAudio` from the host's Home Manager imports and rebuild;
otherwise declarative activation will restore the service.
