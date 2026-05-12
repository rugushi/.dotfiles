{
  packageOverrides = pkgs:
  let
    packagesJSON = builtins.fromJSON (builtins.readFile /root/.nix/packages.json);

    # Flatten all relevant package lists
    allPackages = packagesJSON.dev.base ++ packagesJSON.dev.tool;

    # Resolve strings -> actual nixpkgs derivations
    resolvedPackages = map (name: pkgs.${name}) allPackages;
  in
  {
    packages = pkgs.buildEnv {
      name = "dev-packages";
      paths = resolvedPackages;

      pathsToLink = [
        "/share"
        "/bin"
      ];
    };
  };
}
