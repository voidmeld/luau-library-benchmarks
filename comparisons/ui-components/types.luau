--!strict

local Roblox = require "../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../.lute/dependencies/verify/src/roblox/datatypes"

export type Node = Roblox.Instance & {
	Activated: Roblox.Signal<>,
	DragEnd: Roblox.Signal<>,
	Completed: Roblox.Signal<unknown>,
	Pressed: Roblox.Signal<>,
	StateChanged: Roblox.Signal<unknown>,
	MouseEnter: Roblox.Signal<>,
	MouseLeave: Roblox.Signal<>,
	SelectionGained: Roblox.Signal<>,
}

export type Props = { [unknown]: unknown }
export type Spec = Props

export type ReadOnlyValue<T> = { peek: (ReadOnlyValue<T>) -> T }
export type Value<T> = ReadOnlyValue<T> & { set: (Value<T>, T) -> () }
export type Use = <T>(ReadOnlyValue<T>) -> T
export type Child = unknown

export type KeyedCollectionSpec<K, V> = Spec
export type KeyedTableSpec<V, K> = Spec
export type TableColumn<V, K> = Spec
export type CollectionPlacement = Spec
export type DialogAction = Spec
export type DialogSpec = Spec
export type PickerOption<T> = Spec
export type RadialItem<T> = Spec
export type RadialAction<T> = Spec
export type RadialMenuSpec<T> = Spec
export type Tab = { id: string, label: string, content: () -> Node }
export type NavigationEntry<T> = { id: string, value: T }
export type NavigationDestination<T> = Spec

export type Control = ((string) -> (Props) -> Node) & ((Props) -> Node)

export type Controls = {
	provide: (() -> Node) -> Node,
	environment: (Node?) -> { isLandscape: ReadOnlyValue<boolean>, effectiveInput: ReadOnlyValue<string> },
	draggable: (Node, Props) -> unknown,
	dropTarget: (Node, Props) -> unknown,
	Badge: Control,
	AdaptiveStack: Control,
	Button: Control,
	Card: Control,
	Composition: Control,
	Region: Control,
	Dialog: Control,
	Grid: Control,
	HStack: Control,
	NavigationStack: Control,
	Picker: Control,
	ProgressView: Control,
	RadialMenu: Control,
	ScrollView: Control,
	Slider: Control,
	Stepper: Control,
	TabView: Control,
	Table: Control,
	Text: Control,
	TextInput: Control,
	Toast: Control,
	Toggle: Control,
	VStack: Control,
	VirtualGrid: Control,
	VirtualList: Control,
}

export type Compose = {
	cell: <T>(T) -> Value<T>,
	keyed: (Props) -> unknown,
	portal: (Node, () -> { unknown }) -> unknown,
	static: <T>(T) -> unknown,
	watch: ((Use) -> ()) -> unknown,
	createRootOwner: (() -> (), unknown) -> { dispose: () -> () },
}

export type Runtime = {
	mount: (() -> unknown, Node) -> () -> (),
	constructors: { [string]: (Props) -> Node },
	adopt: (Node) -> (),
	reactor: unknown,
	dispose: (Runtime) -> (),
}

export type Motion = {
	dialog: { enter: number, exit: number },
	toast: { enter: number, exit: number },
	radial: { enter: number, exit: number },
	travel: number,
	present: string,
	travelEase: string,
}

export type ThemePackage = {
	style: { themes: { { colors: { [string]: unknown } } } },
	metrics: {
		typography: { body: { size: number } },
		controls: { typography: { preferredSizeStep: number } },
		motion: {
			dialog: { enter: number, exit: number }?,
			toast: { enter: number, exit: number }?,
			radial: { enter: number, exit: number }?,
			durations: { travel: number? }?,
			easing: { present: string?, travel: string? }?,
		},
	},
}

export type Facet = {
	VERSION: string,
	Compose: Compose,
	controls: (Runtime, Props?) -> Controls,
	Roblox: { createRuntime: (unknown) -> Runtime },
	themes: {
		neutralPackage: () -> ThemePackage,
		createStyleSheet: (Runtime, ThemePackage | ReadOnlyValue<ThemePackage>, Props) -> Node,
	},
}

export type World = {
	Facet: Facet,
	Compose: Compose,
	runtime: Runtime,
	Host: { [string]: (Props) -> Node },
	UI: Controls,
	types: Datatypes.Library,
	motion: Motion,
	toastDuration: number?,
	target: Node,
	textService: Node?,
	guiService: Node?,
	inputService: Node?,
	tweenService: Node?,
	key: ((unknown) -> ())?,
	drag: ((Node, Node) -> ())?,
	heartbeat: Roblox.Signal<number>,
	new: (string) -> Node,
	node: (Roblox.Instance) -> Node,
	destroy: (Node) -> (),
	frame: (number?) -> (),
	spawn: (() -> ()) -> (),
	pin: (Roblox.Instance, number, number) -> (),
	poke: (Roblox.Instance, string, unknown) -> (),
	fire: (Roblox.Instance, string, ...unknown) -> (),
	dispose: () -> (),
}

export type Lane = "plain" | "facet"

export type Scene = {
	step: (number) -> (),
	snapshot: () -> string,
	stop: () -> (),
}

export type Workload = {
	id: string,
	iterations: number,
	what: string,
	prepare: (World, Lane) -> Scene,
}

return {}
