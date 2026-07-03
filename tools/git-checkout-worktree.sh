#!/bin/bash

is_sourced() {
	[[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

validate_parent_directory() {
	local variable_name=$1
	local parent_directory=$2

	if [[ -n "$parent_directory" && ! -d "$parent_directory" ]]; then
		echo "$variable_name does not exist or is not a directory: $parent_directory" >&2
		return 1
	fi
}

list_worktrees_from_parent() {
	local label=$1
	local parent_directory=$2
	local search_term=$3

	[[ -z "$parent_directory" ]] && return 0

	while IFS= read -r directory; do
		local directory_name=$(basename "$directory")

		if [[ -z "$search_term" || "$directory_name" == *"$search_term"* ]]; then
			WORKTREES+=("$directory")
			WORKTREE_LABELS+=("$label")
		fi
	done < <(find "$parent_directory" -mindepth 1 -maxdepth 1 -type d | sort)
}

print_worktrees() {
	local index=1
	local has_be=0
	local has_fe=0

	for label in "${WORKTREE_LABELS[@]}"; do
		[[ "$label" == 'BE' ]] && has_be=1
		[[ "$label" == 'FE' ]] && has_fe=1
	done

	if [[ "$has_be" -eq 1 ]]; then
		echo 'Back End:' >&2
		for i in "${!WORKTREES[@]}"; do
			[[ "${WORKTREE_LABELS[$i]}" != 'BE' ]] && continue
			echo "$index: $(basename "${WORKTREES[$i]}")" >&2
			((index=index+1))
		done
	fi

	if [[ "$has_be" -eq 1 && "$has_fe" -eq 1 ]]; then
		echo >&2
	fi

	if [[ "$has_fe" -eq 1 ]]; then
		echo 'Front End:' >&2
		for i in "${!WORKTREES[@]}"; do
			[[ "${WORKTREE_LABELS[$i]}" != 'FE' ]] && continue
			echo "$index: $(basename "${WORKTREES[$i]}")" >&2
			((index=index+1))
		done
	fi
}

choose_worktree() {
	local selected_index

	while true; do
		read -p 'Enter a worktree number: ' selected_index

		[[ -z "$selected_index" ]] && echo 'Please make an input' >&2 && continue
		[[ ! "$selected_index" =~ ^[0-9]+$ ]] && echo 'Please provide a number' >&2 && continue
		[[ "$selected_index" -lt 1 || "$selected_index" -gt "${#WORKTREES[@]}" ]] && echo 'Number out of range' >&2 && continue

		SELECTED_WORKTREE="${WORKTREES[$((selected_index-1))]}"
		return 0
	done
}

search_term=$1
WORKTREES=()
WORKTREE_LABELS=()

validate_parent_directory 'WORKTREE_PARENT' "$WORKTREE_PARENT" || return 1 2>/dev/null || exit 1
validate_parent_directory 'WORKTREE_FE_PARENT' "$WORKTREE_FE_PARENT" || return 1 2>/dev/null || exit 1

if [[ -z "$WORKTREE_PARENT" && -z "$WORKTREE_FE_PARENT" ]]; then
	echo 'WORKTREE_PARENT and WORKTREE_FE_PARENT are both unset' >&2
	return 1 2>/dev/null || exit 1
fi

list_worktrees_from_parent 'BE' "$WORKTREE_PARENT" "$search_term"
list_worktrees_from_parent 'FE' "$WORKTREE_FE_PARENT" "$search_term"

if [[ "${#WORKTREES[@]}" -eq 0 ]]; then
	echo 'No matching worktree directories found' >&2
	return 1 2>/dev/null || exit 1
fi

if [[ "${#WORKTREES[@]}" -eq 1 ]]; then
	SELECTED_WORKTREE="${WORKTREES[0]}"
else
	print_worktrees
	choose_worktree
fi

if is_sourced; then
	cd "$SELECTED_WORKTREE" || return 1
	echo "Changed directory to: $SELECTED_WORKTREE" >&2
	return 0
fi

if [[ -t 1 ]]; then
	echo 'This command cannot change the current shell directory when executed directly.' >&2
	echo 'Use one of these:' >&2
	echo '  source git-checkout-worktree [pattern]' >&2
	echo '  cd "$(git-checkout-worktree [pattern])"' >&2
fi

echo "$SELECTED_WORKTREE"
