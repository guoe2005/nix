{
  plugins.neorg={
    enable = true;
    modules = {
      "core.dirman" = {
        config = {
          workspaces = {
            home = "~/obsidian/neorg/home";
            work = "~/obsidian/neorg/work";
          };
        };
      };
      "core.defaults" = {
        __empty = null;
      };
    };
  };
}
