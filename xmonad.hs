-- import XMonad hiding (Tall)
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Circle
import XMonad.Layout.Tabbed
import XMonad.Layout.Dishes
import XMonad.Layout.TwoPane
import XMonad.Layout.NoBorders
import XMonad.Layout.Magnifier
import XMonad.Layout.ResizableTile

import XMonad.Layout.MosaicAlt
import qualified Data.Map as M

import System.IO

myTerminal = "rxvt"
myModMask = mod1Mask
myLayouts = Circle ||| TwoPane (3/100) (1/2) ||| Dishes 2 (1/6) ||| MosaicAlt M.empty ||| noBorders Full ||| simpleTabbed ||| magnifier (Tall 1 (3/100) (1/2)) ||| ResizableTall 1 (3/100) (1/2) []

main = do
	xmproc <- spawnPipe "/home/bskahan/bin/xmobar-0.9.bin /home/bskahan/.xmobarrc"
	xmonad defaults

defaults = defaultConfig {
	terminal = myTerminal,
	modMask = myModMask,
	layoutHook = myLayouts
}
