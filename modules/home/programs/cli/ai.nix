{inputs, ...}: {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      pi
      claude-code
    ];

    # Custom Pi extensions
    home.file.".pi/agent/extensions/system-theme.ts".text = ''
      import { existsSync, mkdirSync, readFileSync, watch } from "node:fs";
      import { dirname } from "node:path";
      import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

      const stateFile = `''${process.env.HOME}/.cache/pi-system-theme/theme`;

      function readTheme() {
        if (!existsSync(stateFile)) return undefined;

        const theme = readFileSync(stateFile, "utf8").trim();
        return theme || undefined;
      }

      function applyTheme(ctx: ExtensionContext, previousTheme?: string) {
        if (!ctx.hasUI) return previousTheme;

        const theme = readTheme();
        if (!theme || theme === previousTheme) return previousTheme;

        const result = ctx.ui.setTheme(theme);
        if (!result.success) {
          ctx.ui.notify(`Failed to apply Pi theme ''${theme}: ''${result.error}`, "warning");
          return previousTheme;
        }

        return theme;
      }

      export default function (pi: ExtensionAPI) {
        let closeWatcher: (() => void) | undefined;
        let currentTheme: string | undefined;

        pi.on("session_start", async (_event, ctx) => {
          mkdirSync(dirname(stateFile), { recursive: true });
          currentTheme = applyTheme(ctx, currentTheme);

          const watcher = watch(dirname(stateFile), (eventType, filename) => {
            if (eventType !== "change" && eventType !== "rename") return;
            if (filename?.toString() !== "theme") return;

            currentTheme = applyTheme(ctx, currentTheme);
          });

          closeWatcher = () => watcher.close();
        });

        pi.on("session_shutdown", async () => {
          closeWatcher?.();
          closeWatcher = undefined;
        });
      }
    '';

    home.file.".pi/agent/themes/solarized-dark.json".text = ''
      {
        "$schema": "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
        "name": "solarized-dark",
        "vars": {
          "bg": "#002b36",
          "panel": "#073642",
          "panelAlt": "#0b3c49",
          "selected": "#184956",
          "border": "#2f5a66",
          "accent": "#268bd2",
          "cyan": "#2aa198",
          "green": "#859900",
          "red": "#dc322f",
          "yellow": "#b58900",
          "orange": "#cb4b16",
          "purple": "#6c71c4",
          "text": "#93a1a1",
          "muted": "#839496",
          "dim": "#657b83",
          "toolSuccessBg": "#1c3c30",
          "toolErrorBg": "#3f2b29"
        },
        "colors": {
          "accent": "accent",
          "border": "border",
          "borderAccent": "cyan",
          "borderMuted": "dim",
          "success": "green",
          "error": "red",
          "warning": "yellow",
          "muted": "muted",
          "dim": "dim",
          "text": "",
          "thinkingText": "muted",
          "selectedBg": "selected",
          "userMessageBg": "panel",
          "userMessageText": "",
          "customMessageBg": "panelAlt",
          "customMessageText": "",
          "customMessageLabel": "purple",
          "toolPendingBg": "panelAlt",
          "toolSuccessBg": "toolSuccessBg",
          "toolErrorBg": "toolErrorBg",
          "toolTitle": "accent",
          "toolOutput": "muted",
          "mdHeading": "orange",
          "mdLink": "accent",
          "mdLinkUrl": "muted",
          "mdCode": "cyan",
          "mdCodeBlock": "green",
          "mdCodeBlockBorder": "border",
          "mdQuote": "muted",
          "mdQuoteBorder": "border",
          "mdHr": "border",
          "mdListBullet": "purple",
          "toolDiffAdded": "green",
          "toolDiffRemoved": "red",
          "toolDiffContext": "muted",
          "syntaxComment": "dim",
          "syntaxKeyword": "purple",
          "syntaxFunction": "accent",
          "syntaxVariable": "red",
          "syntaxString": "green",
          "syntaxNumber": "orange",
          "syntaxType": "yellow",
          "syntaxOperator": "cyan",
          "syntaxPunctuation": "text",
          "thinkingOff": "dim",
          "thinkingMinimal": "border",
          "thinkingLow": "accent",
          "thinkingMedium": "cyan",
          "thinkingHigh": "purple",
          "thinkingXhigh": "red",
          "bashMode": "green"
        },
        "export": {
          "pageBg": "#002b36",
          "cardBg": "#073642",
          "infoBg": "#163630"
        }
      }
    '';

    home.file.".pi/agent/themes/solarized-light.json".text = ''
      {
        "$schema": "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
        "name": "solarized-light",
        "vars": {
          "bg": "#fdf6e3",
          "panel": "#eee8d5",
          "panelAlt": "#e7e1cd",
          "selected": "#ddd6c2",
          "border": "#c7c1ae",
          "accent": "#268bd2",
          "cyan": "#2aa198",
          "green": "#859900",
          "red": "#dc322f",
          "yellow": "#b58900",
          "orange": "#cb4b16",
          "purple": "#6c71c4",
          "text": "#586e75",
          "muted": "#657b83",
          "dim": "#93a1a1",
          "toolSuccessBg": "#e7ecd2",
          "toolErrorBg": "#f4e0d5"
        },
        "colors": {
          "accent": "accent",
          "border": "border",
          "borderAccent": "cyan",
          "borderMuted": "dim",
          "success": "green",
          "error": "red",
          "warning": "yellow",
          "muted": "muted",
          "dim": "dim",
          "text": "",
          "thinkingText": "muted",
          "selectedBg": "selected",
          "userMessageBg": "panel",
          "userMessageText": "",
          "customMessageBg": "panelAlt",
          "customMessageText": "",
          "customMessageLabel": "purple",
          "toolPendingBg": "panelAlt",
          "toolSuccessBg": "toolSuccessBg",
          "toolErrorBg": "toolErrorBg",
          "toolTitle": "accent",
          "toolOutput": "muted",
          "mdHeading": "orange",
          "mdLink": "accent",
          "mdLinkUrl": "muted",
          "mdCode": "cyan",
          "mdCodeBlock": "green",
          "mdCodeBlockBorder": "border",
          "mdQuote": "muted",
          "mdQuoteBorder": "border",
          "mdHr": "border",
          "mdListBullet": "purple",
          "toolDiffAdded": "green",
          "toolDiffRemoved": "red",
          "toolDiffContext": "muted",
          "syntaxComment": "dim",
          "syntaxKeyword": "purple",
          "syntaxFunction": "accent",
          "syntaxVariable": "red",
          "syntaxString": "green",
          "syntaxNumber": "orange",
          "syntaxType": "yellow",
          "syntaxOperator": "cyan",
          "syntaxPunctuation": "text",
          "thinkingOff": "dim",
          "thinkingMinimal": "border",
          "thinkingLow": "accent",
          "thinkingMedium": "cyan",
          "thinkingHigh": "purple",
          "thinkingXhigh": "red",
          "bashMode": "green"
        },
        "export": {
          "pageBg": "#fdf6e3",
          "cardBg": "#eee8d5",
          "infoBg": "#f4e9c8"
        }
      }
    '';

    home.file.".pi/agent/extensions/autocommit.ts".text = ''
      import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

      const prompt = `Create conventional commits from all available changes.

      Rules:
      - Do not make one big commit by default.
      - Group files by purpose.
      - Commit each group separately.
      - Use lowercase commit messages so commitlint passes.
      - Do not guess. Understand every available change before committing.
      - If errors occur, do not fix them. Only report them at the end. Limit yourself to the commits.

      Steps:
      1. Inspect repository state with \`git status --short\`, \`git diff --cached\`, \`git diff\`, and \`git ls-files --others --exclude-standard\`.
      2. Detect issue key from branch name with \`git branch --show-current\`. Use clear issue key only; do not invent one.
      3. Group changes semantically: one bug fix, one feature, one refactor, one test update, one docs change, one dependency update, or one config/CI change.
      4. Stage only files or hunks for each group. Use \`git add <file>\` or \`git add -p\`. Do not use \`git add -A\` blindly.
      5. Verify staged diff with \`git diff --cached\` before every commit.
      6. Commit with Conventional Commit format: \`<type>(<scope>): <summary>\`.
      7. Repeat until all intentional changes are committed, or unsafe/ambiguous changes remain unstaged for user decision.
      8. Finish with \`git status --short\`.

      Commit types:
      - feat: new feature
      - fix: bug fix
      - docs: documentation only
      - style: formatting only, no logic change
      - refactor: code change without behavior change
      - perf: performance improvement
      - test: tests added or updated
      - build: build system or dependencies
      - ci: CI/CD changes
      - chore: maintenance
      - revert: revert previous commit

      Message rules:
      - Max 72 characters.
      - Imperative mood: add, fix, update, remove.
      - Lowercase type and scope.
      - Lowercase summary unless proper noun requires otherwise.
      - No period at end.
      - Specific purpose, not file name.
      - No vague words: changes, stuff, misc, wip.

      Never commit secrets, .env values, API keys, tokens, credentials, debug logs, local editor files, temporary files, build artifacts unless tracked intentionally, or unrelated experiments.

      Report minimal summary: commits created, files intentionally left uncommitted, anything skipped for safety.`;

      export default function (pi: ExtensionAPI) {
        pi.registerCommand("autocommit", {
          description: "Create semantic commits from all available changes",
          handler: async (_args, ctx) => {
            if (!ctx.isIdle()) {
              pi.sendUserMessage(prompt, { deliverAs: "followUp" });
              ctx.ui.notify("Autocommit queued", "info");
              return;
            }

            pi.sendUserMessage(prompt);
          },
        });
      }
    '';
  };
}
