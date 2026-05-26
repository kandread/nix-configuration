# NixOS & Nix-Darwin Dendritic Configuration

A dendritic NixOS configuration using [den](https://den.denful.dev/), an aspect-oriented framework for composable, cross-platform Nix configurations.

## Structure

```
.
├── flake.nix               # Entrypoint — delegates everything to modules/
├── flake.lock
├── modules/
│   ├── den.nix             # Den flake module + home-manager wiring
│   ├── defaults.nix        # Global defaults applied to all hosts and users
│   ├── hosts.nix           # Host and user entity declarations
│   │
│   ├── hosts/              # Per-host aspects and hardware config
│   │   ├── x1gland/        # ThinkPad X1 Carbon (laptop)
│   │   ├── workgland/      # Workstation
│   │   └── minigland/      # Mini PC
│   │
│   ├── kandread.nix    # User aspect — composes all user-facing aspects
│   ├── audio.nix       # Pipewire audio
│   ├── calendar.nix    # Khal + vdirsyncer
│   ├── comms.nix       # Zulip, Zoom
│   ├── davmail.nix     # DavMail Exchange gateway (home-manager service)
│   ├── devel.nix       # Development tools
│   ├── emacs.nix       # Emacs (emacs-git-pgtk + packages)
│   ├── email.nix       # mu + mbsync + account config
│   ├── fish.nix        # Fish shell + plugins
│   ├── fonts.nix       # System fonts (Nerd Fonts, Fira, etc.)
│   ├── git.nix         # Git config
│   ├── gpg.nix         # GPG agent + pinentry
│   ├── kitty.nix       # Kitty terminal
│   ├── llm.nix         # LLM tools (Ollama, etc.)
│   ├── locale.nix      # Timezone and locale
│   ├── media.nix       # Multimedia tools
│   ├── networking.nix  # NetworkManager
│   ├── pdf.nix         # PDF tools
│   ├── sops.nix        # Secrets management via sops-nix + GPG
│   ├── ssh.nix         # SSH client config
│   ├── tailscale.nix   # Tailscale VPN
│   ├── utilities.nix   # CLI utilities
│   └── writing.nix     # LaTeX, Typst, Pandoc
└── secrets/                # sops-encrypted secrets (secrets.yaml)
```

## Design

This configuration uses [den](https://den.denful.dev/)'s aspect-oriented model rather than traditional NixOS module files. The key ideas:

**Aspects** are the primary unit of configuration. Each aspect bundles NixOS, home-manager, and user-level config for a single concern in one place. For example, `emacs.nix` sets the nixpkgs overlay (NixOS), installs the package and extraPackages (home-manager), all in one file.

**Composition** happens through `includes`. The `kandread` user aspect includes all user-facing aspects. Host aspects include desktop environment and hardware aspects. Cross-cutting concerns like fonts and tailscale are in `den.default.includes` and applied everywhere.

**Entities** are declared in `hosts.nix` — hosts and their users. Each host's `default.nix` declares host-specific aspects (desktop environment, hardware-specific services).

## Hosts

| Host | Platform | Description |
|------|----------|-------------|
| `x1gland` | `x86_64-linux` | ThinkPad X1 Carbon, GNOME |
| `workgland` | `x86_64-linux` | Workstation, NVIDIA |
| `minigland` | `x86_64-linux` | Mini PC |

## Adding a New Host

1. Add the host declaration in `modules/hosts.nix`:
   ```nix
   den.hosts.x86_64-linux.newhostname.users.kandread = { };
   ```

2. Create `modules/hosts/newhostname/hardware.nix` with hardware config (from `nixos-generate-config`), wrapped in a den aspect:
   ```nix
   { den, ... }:
   {
     den.aspects.newhostname.nixos = { ... }: {
       # hardware config here
     };
   }
   ```

3. Create `modules/hosts/newhostname/default.nix` with host-specific aspects:
   ```nix
   { den, ... }:
   {
     den.aspects.newhostname.nixos = { ... }: {
       networking.hostName = "newhostname";
       # other host-specific config
     };
   }
   ```

## Adding a New Aspect

Create a file in `modules/` — `import-tree` picks it up automatically:

```nix
{ ... }:
{
  den.aspects.myfeature = {
    nixos = { pkgs, ... }: {
      # NixOS config
    };
    homeManager = { pkgs, ... }: {
      # home-manager config
    };
  };
}
```

Then include it where needed — in `kandread.nix` for user-facing features, in a host's `default.nix` for host-specific features, or in `defaults.nix` for everything.

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) using GPG encryption. The encrypted `secrets/secrets.yaml` is committed to the repo; plaintext never is.

To edit secrets:
```bash
sops secrets/secrets.yaml
```

To add a new host key to the secrets, add its GPG fingerprint to `secrets/.sops.yaml` and re-encrypt:
```bash
sops updatekeys secrets/secrets.yaml
```

## Applying

```bash
# Build and switch (current host)
nixos-rebuild switch --flake .#

# Build without switching
nixos-rebuild build --flake .#

# Check evaluation
nix flake check
```
