--!strict

export type Cell<T> = { read: () -> T, write: (T) -> (), release: () -> () }
export type State = {
	value: <T>(T, (T) -> ()) -> Cell<T>,
	batch: (() -> ()) -> (),
}

return {}
