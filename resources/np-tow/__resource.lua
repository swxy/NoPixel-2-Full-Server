resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
    'carvariations.meta',
    'carcols.meta'
}

data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'

client_script {
    'towlivery_names.lua'
}