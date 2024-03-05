#encryptionKeyFile = 'test'
function encryptString() {
  echo "echo $1 | openssl enc -aes-256-cbc -a -salt -pass file:$encryptionKeyFile"
  echo $1 | openssl enc -aes-256-cbc -a -salt -pass file:$encryptionKeyFile
}

function decryptString() {
  echo "echo $1 | openssl enc -aes-256-cbc -a -d -salt -pass file:$encryptionKeyFile"
  echo $1 | openssl enc -aes-256-cbc -a -d -salt -pass file:$encryptionKeyFile
}
