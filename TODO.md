# Smart Event Check-in & Crowd Management App - TODO

## Progress
- [x] Step 1: Add Flutter dependencies + basic app shell + state setup files
- [x] Step 2: Create app structure (routing + 4 screens)
- [x] Step 3: Implement core functional logic (event setup, check-in validation, logs search)
- [ ] Step 4: Offline-first persistence & sync-ready pipeline (Hive + adapters + sync service)
- [ ] Step 5: QR scanning wiring (replace demo QR mock)
- [ ] Step 6: Fix remaining build/runtime issues (notably Windows symlink requirement)
- [ ] Step 7: Ensure at least 4 commits in GitHub repo and finalize README

## Notes
- Hive model code currently includes generated *.g.dart files manually; in a real build we should generate via build_runner after setup.
- Windows build fails due to missing symlink support (Developer Mode needed). Code can still be completed for Android/iOS.

