`make clean deploy` to:

1. export legacy data from `LEGACY_SERVER`
1. update it as necessary
1. deploy `periodo-server` [`@pre-renaming`](https://github.com/periodo/periodo-server/tree/pre-renaming) to `TARGET_SERVER`
1. apply necessary data patches
1. deploy `periodo-server` `@HEAD` to `TARGET_SERVER`
