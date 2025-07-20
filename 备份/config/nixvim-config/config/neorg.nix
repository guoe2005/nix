{
  plugins.neorg={
    enable = false;
    modules = {
      "core.dirman" = {
        config = {
          workspaces = {
            home = "~/obsidian/neorg/home";
            work = "~/obsidian/neorg/work";
            notes = "~/obsidian/neorg/notes";
          };
        };
      };
      "core.defaults" = {
        __empty = null;
      };
      "core.journal" = {
        config = {
          strategy = "flat";
          workspace = "notes";
        };
      };
    };
  };
}
