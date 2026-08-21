extends Node

## Stores the UIDs of the songs in a dictionary.
const SONG_PATHS: Dictionary[String, String] = {
	"Jinx_Noir": "uid://xglqccmip2lw",
	"Uma_chamada_misteriosa": "uid://4iq4vun1rw2c",
	"Jazz_sangrento": "uid://op3elpnq264q"
}

## Stores the UIDs of the scenes in a dictionary.
const SCENE_PATHS: Dictionary[String, String] = {
	"main_menu": "uid://n0lx6rvo7ub7",
	"credits": "uid://dwyp4jdf31vxg",
	"chapter_1_intro": "uid://tdovpqa1vmlo",
	"continue": "uid://c7l652ow2t2xl",
	"office": "uid://dd3ja6w7yaep0",
	"alley": "uid://cnw2ei7sdvg4l",
	"ritual_room": "uid://6dm6tvn0abm4",
}

const SCENE_DISPLAY_NAMES: Dictionary[String, String] = {
	"office": "Escritório",
	"alley": "Beco",
	"ritual_room": "Sala de ritual",
	}

const CHAPTER: Dictionary[String, int] = {
	"office": 1,
	"alley": 1,
	"ritual_room": 1,
} 
