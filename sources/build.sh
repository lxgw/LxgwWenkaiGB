rm -r sources/temp
rm -r sources/build
mkdir -p sources/temp
mkdir -p sources/build
# unzip
python3 sources/shared/scripts/extract.py sources/shared/gblite gblite
python3 sources/shared/scripts/extract.py sources/shared/fulldiff fulldiff
# gb full
ufomerge --output sources/build/LXGWWenKaiGB-Light.ufo --skip-existing --ignore-layout sources/temp/gblite/Light.ufo sources/temp/fulldiff/Light.ufo
ufomerge --output sources/build/LXGWWenKaiGB-Regular.ufo --skip-existing --ignore-layout sources/temp/gblite/Regular.ufo sources/temp/fulldiff/Regular.ufo
ufomerge --output sources/build/LXGWWenKaiGB-Medium.ufo --skip-existing --ignore-layout sources/temp/gblite/Medium.ufo sources/temp/fulldiff/Medium.ufo
# mono full
ufomerge --output sources/build/LXGWWenKaiMonoGB-Light.ufo --skip-existing --ignore-layout sources/shared/monolgc/Light.ufo sources/build/LXGWWenKaiGB-Light.ufo
ufomerge --output sources/build/LXGWWenKaiMonoGB-Regular.ufo --skip-existing --ignore-layout sources/shared/monolgc/Regular.ufo sources/build/LXGWWenKaiGB-Regular.ufo
ufomerge --output sources/build/LXGWWenKaiMonoGB-Medium.ufo --skip-existing --ignore-layout sources/shared/monolgc/Medium.ufo sources/build/LXGWWenKaiGB-Medium.ufo
# fontinfo override
cp sources/fontinfo/LXGWWenKaiGB-Light.plist sources/build/LXGWWenKaiGB-Light.ufo/fontinfo.plist
cp sources/fontinfo/LXGWWenKaiGB-Regular.plist sources/build/LXGWWenKaiGB-Regular.ufo/fontinfo.plist
cp sources/fontinfo/LXGWWenKaiGB-Medium.plist sources/build/LXGWWenKaiGB-Medium.ufo/fontinfo.plist
cp sources/fontinfo/LXGWWenKaiMonoGB-Light.plist sources/build/LXGWWenKaiMonoGB-Light.ufo/fontinfo.plist
cp sources/fontinfo/LXGWWenKaiMonoGB-Regular.plist sources/build/LXGWWenKaiMonoGB-Regular.ufo/fontinfo.plist
cp sources/fontinfo/LXGWWenKaiMonoGB-Medium.plist sources/build/LXGWWenKaiMonoGB-Medium.ufo/fontinfo.plist
# feature override
cp sources/shared/gblite/features.fea sources/build/LXGWWenKaiGB-Light.ufo/features.fea
cp sources/shared/gblite/features.fea sources/build/LXGWWenKaiGB-Regular.ufo/features.fea
cp sources/shared/gblite/features.fea sources/build/LXGWWenKaiGB-Medium.ufo/features.fea
cp sources/shared/gblite/features_mono.fea sources/build/LXGWWenKaiMonoGB-Light.ufo/features.fea
cp sources/shared/gblite/features_mono.fea sources/build/LXGWWenKaiMonoGB-Regular.ufo/features.fea
cp sources/shared/gblite/features_mono.fea sources/build/LXGWWenKaiMonoGB-Medium.ufo/features.fea
