class Persona{
	var edad
	var tipo
	var property felicidonios
	const  carrerasQueSeQuiereRecebir = #{}
	const  carrerasQueSeRecibio = #{}
	var property plataQueQuiereGanar
	const lugaresQueQuiereVisitar = #{}
	const lugaresVisitados = #{}
	var  hijos
	const  suenios = []
	
	method aumentarFelicidonios(cant){
		felicidonios += cant
	}
	method tieneHijos() = hijos > 0
	method sumarHijo(cant){
		hijos += cant
	}
	method viajarA(lugar){
		lugaresVisitados.add(lugar)
	}
	method ganaMal(sueldo) = sueldo < plataQueQuiereGanar
	method recibirse(carrera){
		carrerasQueSeRecibio.add(carrera)
	}
	method quiereEstudiar(carrera) = carrerasQueSeQuiereRecebir.contains(carrera)
	method estaRecibido(carrera) = carrerasQueSeRecibio.contains(carrera)
	method esFeliz() = felicidonios > self.sueniosPendientes().sum({suenio=>suenio.felicidonios()})
	method esAmbiciosa() = self.sueniosAmbiciosos().size() > 3
	method sueniosAmbiciosos() = suenios.filter({suenio => suenio.esAmbicioso()})
	method cumplirSuenio(suenio){
			if(self.sueniosPendientes().contains(suenio))
			suenio.cumplirSuenio(self)
	}
	method cumplirSuenioMasPresiado(){
		var suenioACumplir = tipo.suenioMasPresiado(self)
		self.cumplirSuenio(suenioACumplir)
	}
	method sueniosPendientes()= suenios.filter({suenio=>suenio.pendiente()})
}
object obsesivo{
	method suenioMasPresiado(persona) = persona.sueniosPendientes().first()
}
object realista{
	method suenioMasPresiado(persona) = persona.sueniosPendientes().max({suenio => suenio.felicidonios()})
}
object alocado{
	method suenioMasPresiado(persona) = persona.sueniosPendientes().anyOne()
}

class Suenio{
	var cumplido = false
	method pendiente() = !cumplido
	method felicidonios()  
	method esAmbicioso() = self.felicidonios() > 100
	method aumentarFelicidoniosA(persona){
		persona.aumentarFelicidonios(self.felicidonios())
	}
	method cumplirSuenio(persona){
		self.validar(persona)
		self.realizar(persona)
		self.aumentarFelicidoniosA(persona)
		self.cumplir()
	}
	method cumplir(){
		cumplido = true
	}
	method validar(_)
	method realizar(_)
}

class SuenioSimple inherits Suenio{
	var felicidonios 
	override method felicidonios() = felicidonios
}

class RecibirseDeCarrera inherits SuenioSimple{
	const carrera
	override method validar(persona){
		if(!persona.quiereEstudiar(carrera)) self.error("La persona no quiere recibirse de esa carrera")
		if(persona.estaRecibido(carrera)) self.error("La persona ya se recibio en la carrera")
	}
	override method realizar(persona){
		persona.recibirse(carrera)
	}
}

class TenerUnHijo inherits SuenioSimple{
	override method validar(_){}
	override method realizar(persona){
		persona.sumarHijo(1)
	}
}
class AdoptarHijos inherits SuenioSimple{
	var cant 
	override method validar(persona){
		if(persona.tieneHijos()) self.error("La persona no puede adoptar si ya tiene hijos")
	}
	override method realizar(persona){
		persona.sumarHijo(cant)
	}
}

class Viajar inherits SuenioSimple{
	const destino
	override method validar(_){}
	override method realizar(_){}
}

class ConseguirLaburo inherits SuenioSimple{
	var sueldo
	override method validar(persona){	
		if(persona.ganaMal(sueldo)) self.error("Gana menos de lo que pretende")
	}
	override method realizar(_){}
}

class SuenioMultiple inherits Suenio{
	const suenios = []
	
	override method felicidonios() = suenios.sum({suenio => suenio.felicidonios()})
	override method validar(persona) = suenios.forEach({suenio => suenio.validar(persona)})
	override method realizar(persona) = suenios.forEach({suenio => suenio.realizar(persona)})
}