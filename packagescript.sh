#!/bin/bash
echo "Creating new love2D package."
echo "1. Zipping LOVE Project"
zip bin/Package/game.love LOVEProject/.
echo "2. Zipping Linux Archive"
tar -pczf bin/linuxpkg.tar.gz bin/Package/.
echo "3. ????"
echo "4. Profit!"
