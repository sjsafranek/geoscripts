package pathfinding

// stringInSlice loops through a []string and returns a bool if string is found
// @param a {string} string to find
// @param list {[]string} array of strings to search
// @returns bool
func StringInSlice(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}
