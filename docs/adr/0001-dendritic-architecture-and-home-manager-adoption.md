# ADR 0001: Dendritic Architecture and Home Manager Adoption

- Status: Accepted
- Date: 2026-04-18

## Context

This repository currently uses `flake-parts` and `import-tree` with a small but growing NixOS setup.
The immediate scope is Linux only, with one active host:

- `matebook-d15` (laptop, NixOS)

`blackout` is intentionally not active right now and will be reintroduced later with the same composition pattern.

The long-term scope includes macOS (`nix-darwin`) and potentially more systems, so the architecture must be scalable from the start.

We want to follow a dendritic, feature-centric pattern with strong composability, low duplication, and clear responsibility boundaries.

## Decision

We adopt a **strong dendritic architecture** based on:

- `flake-parts` as top-level module system
- `import-tree` for automatic module loading
- a single repository entrypoint for modules: `import-tree ./modules`

We explicitly **do not adopt `den` at this stage**.

### Structural rules

1. Keep a single modules root:
   - `modules/`
2. Keep architecture explicit by domain under that root:
   - `modules/nixos/`
   - `modules/home/`
   - `modules/home/programs/cli/`
   - `modules/home/programs/desktop/`
   - `modules/home/profiles/`
   - `modules/hosts/`
3. Treat non-entrypoint Nix files as top-level flake-parts modules.

### Module class strategy

Use class-specific module namespaces so features can scale across OS classes:

- `flake.modules.nixos.<aspect>`
- `flake.modules.homeManager.<aspect>`
- `flake.modules.darwin.<aspect>` (documented now, activated later)
- `flake.modules.generic.<aspect>` (shared constants/helpers/options when needed)

### Home Manager strategy

Home Manager is adopted now, embedded in NixOS first.

- Import `inputs.home-manager.flakeModules.home-manager`.
- Move user-space program configuration to Home Manager over time.
- Keep system-level responsibilities in NixOS modules.
- Compose user environments from capability profiles rather than host-kind profiles:
  - `profileCommon`
  - `profileDev`
  - `profileGui`

### Design principles

- **Single Responsibility Principle (SRP)**: each module has one clear concern.
- **DRY**: avoid duplicated config across NixOS/Home Manager.
- **Open/Closed Principle**: add hosts/features by composition, not rewrites.
- **Feature-centric design**: organize and name modules by features/aspects.

### Responsibility boundaries

- `nixos` modules: system scope only (boot, kernel, hardware, networking, system services, base users).
- `homeManager` modules: user scope (program configs, dotfiles, user services, day-to-day UX).
- `perSystem`: architecture-specific artifacts (`packages`, `checks`, `apps`, `devShells`) reused by classes.

### Explicit anti-patterns

- Avoid broad `specialArgs` / `extraSpecialArgs` passthrough patterns for cross-class sharing.
- Prefer top-level options (`generic` modules), local `let` bindings, and standard module composition.

## Consequences

### Positive

- Clear long-term path from Linux-only to Linux + Darwin.
- Easier feature reuse across classes with lower duplication.
- Cleaner host definitions (hosts compose features, not vice versa).
- Smaller and simpler `flake.nix` with logic distributed into modules.

### Trade-offs

- Requires discipline in module boundaries.
- Initial migration effort from existing NixOS-only user-space modules.
- More up-front architecture work compared to ad-hoc host-centric growth.

## Current scope and staged rollout

### Active now (implemented target)

- Linux only.
- Active host:
  - `matebook-d15` (laptop)
- `blackout` remains deferred until Linux baseline on `matebook-d15` is fully stabilized.

### Future-ready (documented, not active yet)

- Add Darwin class modules under `flake.modules.darwin.<aspect>`.
- Introduce `darwinConfigurations` when a macOS host is onboarded.
- Reuse as many existing aspects as possible with class-specific implementations.

## Migration plan

1. Add Home Manager flake-parts integration.
2. Create `modules/home/` base and home profiles.
3. Migrate low-risk user programs first (`git`, `zsh`, `starship`, `ssh`, `zoxide`, `lazygit`).
4. Migrate UI user-space modules where official HM modules exist (e.g. `waybar`, `swaync`).
5. Keep NixOS modules focused on true system responsibilities.
6. Keep Darwin-ready class layout documented and consistent during Linux-only phase.

## Naming and conventions

- Use `kebab-case` for files and directories.
- Keep `default.nix` as an aggregator only where useful.
- Keep host layouts symmetrical for maintainability.
- Prefer profile names by capability (e.g. `common`, `dev`, `gui`) instead of device labels (e.g. `laptop`, `desktop`).

## Related docs

- Formatting and hook workflow: `docs/code-style.md`
