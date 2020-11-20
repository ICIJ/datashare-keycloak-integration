#!/usr/bin/env sh

mkdir -p datashare-data
curl -s -c /tmp/icij_demo.cookie https://datashare-demo.icij.org > /dev/null
curl -s -b /tmp/icij_demo.cookie -o datashare-data/doc1.pdf https://datashare-demo.icij.org/api/luxleaks/documents/src/e4d40cb50f4f21789acafd2d062948258a0f19666d9b4b1b509177e1e7360d58bc547babc5a16c8ecaa72d891477f733?routing=e4d40cb50f4f21789acafd2d062948258a0f19666d9b4b1b509177e1e7360d58bc547babc5a16c8ecaa72d891477f733
curl -s -b /tmp/icij_demo.cookie -o datashare-data/doc2.pdf https://datashare-demo.icij.org/api/luxleaks/documents/src/4badd5eaf63a7276dfa2d0fe8c459d754a96e5c68b27ecfa4aaba0d81eb35eb1c4810695842b6f7b035af68ef6fb863c?routing=4badd5eaf63a7276dfa2d0fe8c459d754a96e5c68b27ecfa4aaba0d81eb35eb1c4810695842b6f7b035af68ef6fb863c
curl -s -b /tmp/icij_demo.cookie -o datashare-data/doc3.pdf https://datashare-demo.icij.org/api/luxleaks/documents/src/49d22c47c02c6e436d88534b25d343356c593d19fe62c79b94daf27397c47b580c33816b1a9ce11a1fe7da3196a85fa6?routing=49d22c47c02c6e436d88534b25d343356c593d19fe62c79b94daf27397c47b580c33816b1a9ce11a1fe7da3196a85fa6
curl -s -b /tmp/icij_demo.cookie -o datashare-data/doc4.pdf https://datashare-demo.icij.org/api/luxleaks/documents/src/dc79b9fc502ac6c0667b15d416a209dc18152204073f1c48ec2474dcaadea62460c56f4cb753fa9427a0502cdd73ee4f?routing=dc79b9fc502ac6c0667b15d416a209dc18152204073f1c48ec2474dcaadea62460c56f4cb753fa9427a0502cdd73ee4f
curl -s -b /tmp/icij_demo.cookie -o datashare-data/doc5.pdf https://datashare-demo.icij.org/api/luxleaks/documents/src/5375ec7c35df9f4640233aa58586915485f893e52e6642d900657ea9e3e1e16ffd024dc2535693bb7765a7c5ff29c742?routing=5375ec7c35df9f4640233aa58586915485f893e52e6642d900657ea9e3e1e16ffd024dc2535693bb7765a7c5ff29c742

docker run --rm --network datashare-keycloak-integration_intranet -v ${PWD}/datashare-data:/home/datashare/data -ti icij/datashare:8.1.5 -m CLI -d /home/datashare/data --stages SCAN,INDEX -p leak1