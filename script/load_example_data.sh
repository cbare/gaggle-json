cd public/examples
curl -v --request PUT -H "Content-Type: application/json" --upload-file namelist.json http://127.0.0.1:3000/documents/4da60f351ff236120b000003
curl -v --request PUT -H "Content-Type: application/json" --upload-file matrix.json http://127.0.0.1:3000/documents/4da60fd51ff236120b000004
curl -v --request PUT -H "Content-Type: application/json" --upload-file network.json http://127.0.0.1:3000/documents/4da612601ff236120b000005
curl -v --request PUT -H "Content-Type: application/json" --upload-file tuple.node.attributes.json http://127.0.0.1:3000/documents/4da613a91ff236120b000006
curl -v --request PUT -H "Content-Type: application/json" --upload-file tuple.bicluster.json http://127.0.0.1:3000/documents/4da613c71ff236120b000007
curl -v --request PUT -H "Content-Type: application/json" --upload-file tuple.command.json http://127.0.0.1:3000/documents/4da613fc1ff236120b000008
curl -v --request PUT -H "Content-Type: application/json" --upload-file table.json http://127.0.0.1:3000/documents/4da614391ff236120b000009
cd ../..
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002 --data '{"name":"Test project", "description":"A project holding example Gaggle data objects"}'
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002/documents/4da60f351ff236120b000003
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002/documents/4da60fd51ff236120b000004
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002/documents/4da612601ff236120b000005
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002/documents/4da613a91ff236120b000006
curl --request PUT http://localhost:3000/projects/4db9e0b557305b6adc000002/documents/4da614391ff236120b000009
