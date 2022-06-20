/* Pre: n ≥ 0
 * Post: factorial(n) = (Πα∈[1,n].α)
 */
int factorial(const int n) {
	// caso base: n = 0 -> factorial(0) = 1
	int r = 1;

	if (n != 0) {
		// caso recurrente: n > 0 -> factorial(n) = n * factorial(n-1)
		r = n * factorial(n-1);
	}
	// assert r = (Πα∈[1,n].α)

	return r;
}

//---------------------------------------
// Ejemplo de uso (invocación con n = 5)
int main() {
	int n = 5;
	int s = 0;
	s = factorial(n);
	while(1){;} // espera activa (no hay sistema operativo)
}
