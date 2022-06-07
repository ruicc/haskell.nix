final: prev: {
  herp.find-netrc = netrc-file:
    let
      add-msg = netrc: to-msg: { inherit netrc; msg = to-msg netrc; };
      path-exists = set: set.netrc != "" && set.netrc != null && builtins.pathExists set.netrc;
      when-not-found = add-msg null (_: "netrc not found");
      found = prev.lib.findFirst
        path-exists
        when-not-found
        [ (add-msg netrc-file (path: "netrc-file(${path}) found"))
          (add-msg (builtins.getEnv "NETRC") (path: "NETRC(${path}) found"))
          (add-msg (builtins.getEnv "PWD" + "/.netrc") (path: ".netrc(${path}) found"))
          (add-msg (builtins.getEnv "HOME" + "/.netrc") (path: ".netrc(${path}) found"))
          (add-msg "/etc/nix/netrc" (path: "netrc(${path}) found"))
        ];
    in builtins.trace found.msg found.netrc;
}
