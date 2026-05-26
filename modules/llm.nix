{ ... }:
{
  den.aspects.llm = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        claude-code
        claude-agent-acp
        opencode
        opencode-claude-auth
        pi-coding-agent
        ollama
      ];
    };
  };
}
