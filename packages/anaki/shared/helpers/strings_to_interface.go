package helpers

func ConvertStringsToInterfaces(args []string) []interface{} {
	interfaces := make([]interface{}, len(args))
	for i, arg := range args {
		interfaces[i] = arg
	}
	return interfaces
}
