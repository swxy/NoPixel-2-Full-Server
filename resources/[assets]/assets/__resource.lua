resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "@np-errorlog/client/cl_errorlog.lua"
this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/misc/shell-mansion/v_int_44.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/slbBuildings/def_props.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'burgerUPDATE/iv_int_1_timecycle_mods_1.xml'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'burgerUPDATE/interiorproxies.meta'
data_file 'SCALEFORM_DLC_FILE' 'burgerUPDATE/minimap/int2056887296.gfx'
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_1a.ytyp'
data_file "HANDLING_FILE" "handling.meta"
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_2a.ytyp'

data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_3a.ytyp'

data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_4a.ytyp'

data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle.xml'
data_file 'GTXD_PARENTING_DATA' 'client/mph4_gtxd.meta'


files {'v_kitch.ytyp'}
data_file 'DLC_ITYP_REQUEST' 'missionrowpdv2/int_corporate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'missionrowpdv2/v_kitch.ytyp'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'missionrowpdv2/interiorproxies.meta'
files {
	"handling.meta",
	'iv_int_1_timecycle_mods_1.xml',
	'audio/ivbsoverride_game.dat151.rel',
	'interiorproxies.meta',
	'gabz_bennys_timecycle.xml'
	
}

client_scripts {
    'client_script.lua',
}