{
  plugins.orgmode = {
    enable = false;
    settings = {
      org_agenda_files = "~/obsidian/orgfiles/**/*";
      org_default_notes_file = "~/obsidian/orgfiles/refile.org";
      org_capture_templates = {
        r = {
          description = "Repo";
          template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?";
          target = "~/obsidian/orgfiles/repos.org";
        };
        T = {
          description = "Todo";
          template = "* TODO %?\n %u";
          target = "~/obsidian/orgfiles/todo.org";
        };
        j = {
          description = "Journal";
          template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n%?";
          target = "~/obsidian/orgfiles/journal.org";
        };
        J = {
          description = "Journal";
          template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n%?";
          target = "~/obsidian/orgfiles/journal/%<%Y-%m>.org";
        };
        e = {
          description = "Event";
          subtemplates = {
            r = {
              description = "recurring";
              template = "** %?\n %T";
              target = "~/obsidian/orgfiles/calendar.org";
              headline = "recurring";
            };
            o = {
              description = "one-time";
              template = "** %?\n %T";
              target = "~/obsidian/orgfiles/calendar.org";
              headline = "one-time";
            };
          };
        };
      };    
    };
  };
}
