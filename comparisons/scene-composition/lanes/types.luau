--!strict

local Environment = require "../cost-model"

export type Row = { id: number }
export type Source<T> = {
	binding: unknown,
	read: () -> T,
	write: (T) -> (),
	bind: ((T) -> unknown) -> unknown,
	watch: (((T) -> ()) -> () -> ())?,
}
export type Properties = { [unknown]: unknown }
export type ModelRow = {
	id: number,
	label: Source<string>,
	selected: Source<boolean>,
	highlight: unknown,
	select: () -> (),
	remove: () -> (),
}
export type CounterState = { node: unknown, write: (number) -> () }
export type RowState = { label: Source<string>, selected: Source<boolean>, highlight: unknown }
export type Use = <T>(Source<T>) -> T
export type Compute = <T>((Use) -> T) -> Source<T>
export type Scope = {
	computed: Compute?,
	select: (<T, U>(Source<T>, (T) -> U) -> Source<U>)?,
	coherentComputed: Compute?,
	provideTheme: ((Source<string>, () -> unknown) -> unknown)?,
	themeText: (() -> unknown)?,
	themeNode: (() -> unknown)?,
	rowState: ((string) -> RowState)?,
	value: <T>(T) -> Source<T>,
	node: (string, Properties, { unknown }?) -> unknown,
	keyed: (Source<{ Row }>) -> unknown,
	rows: ((Source<{ ModelRow }>) -> unknown)?,
	branch: (Source<boolean>, (Scope) -> unknown) -> unknown,
	event: (string) -> unknown,
	counterState: (number) -> CounterState,
	spring: (Source<number>, number) -> unknown,
}
export type Driver = {
	mount: (Environment.Instance, (Scope) -> unknown) -> () -> (),
	batch: (() -> ()) -> (),
}

return {}
