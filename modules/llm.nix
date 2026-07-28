{ inputs, ... }:
{
  den.aspects.llm = {
    nixos = { ... }: {
      nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];
    };
    homeManager = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];
      home.packages = with pkgs; [
        llm-agents.claude-code
        llm-agents.claude-agent-acp
        llm-agents.opencode
        opencode-claude-auth
        llm-agents.pi
        ollama
      ];
    };
  };
}
