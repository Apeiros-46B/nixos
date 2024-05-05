{ system, inputs, ... }:

{
	environment.systemPackages = [
		inputs.st.packages.${system}.st-snazzy
	];
}
