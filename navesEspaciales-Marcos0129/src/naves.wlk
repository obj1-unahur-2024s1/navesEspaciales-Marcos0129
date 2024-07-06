class Nave{
    var velocidad = 0
    var direccionAlSol
    var combustible = 0
       
    method acelerar(cuanto){
        velocidad = 100000.min(velocidad + cuanto)
    }
    
    method desacelerar(cuanto){
        velocidad = 0.max(velocidad - cuanto)
    }
    
    method irAlSol(){
        direccionAlSol = 10
    }
    method escaparDelSol(){
        direccionAlSol = -10
    }
    method ponerseParaleloAlSol(){
        direccionAlSol = 0
    }
    
    method acercarseUnPocoAlSol(){
        direccionAlSol = 10.min(direccionAlSol + 1)
    }
    
    method alejarseDelSol(){
        direccionAlSol = -10.max(direccionAlSol -1 )
    }
    
    method prepararViaje(){
        self.cargarCombustible(30000)
        self.acelerar(5000)
    }
    
    method cargarCombustible(cant){
        combustible += cant
    }
    
    method descargarCombustible(cant){
        0.max(combustible - cant)
    }
    
    method estaTranquila()= combustible >= 4000 and velocidad < 12000
    
    method recibirAmenaza(){
    	self.escapar()
    	self.avisar()
    }
    
    method escapar(){}
    method avisar(){}
    
    method relajo() = self.estaTranquila()
}

class NaveBaliza inherits Nave{
    var colorActual
    var cantidadDeCambios = 0
    
    method cambiarColorDeBaliza(colorNuevo){
        colorActual = colorNuevo
        cantidadDeCambios= cantidadDeCambios+1
    }
    
    override method prepararViaje(){
        super()
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
    }
    
    override method estaTranquila()= super() and colorActual != "rojo"
    
    override method escapar(){
    	self.irAlSol()
    }
    
    override method avisar(){
    	self.cambiarColorDeBaliza("Rojo")
    }
    
    override method relajo() = super() and cantidadDeCambios == 0
}

class NaveDePasajeros inherits Nave{
    var property cantidadDePasajeros
    var property racionComida
    var property racionBebida
    var racionesDadas = 0
    
    
    method cargarComida(cant){
        racionComida += cant
    }
    
    method descargarComida(cant){
        racionComida -= cant
        racionesDadas = racionesDadas + cant
    }
    
    method cargarBebidas(cant){
        racionBebida += cant
    }
    
    method descargarBebidas(cant){
        racionBebida -= cant
    }
    
    override method prepararViaje(){
        super()
        self.cargarComida(4 * cantidadDePasajeros)
        self.cargarBebidas(6 * cantidadDePasajeros)
        self.acercarseUnPocoAlSol()
    }
    
    override method escapar(){
    	velocidad = velocidad *2
    }
    
    override method avisar(){
    	self.descargarComida(cantidadDePasajeros)
    	self.descargarBebidas(cantidadDePasajeros*2)
    }
    
    override method relajo() = super() and racionesDadas < 50
}

class NaveDeCombate inherits Nave{
    var estaInvisible
    var property misilesDesplegados
    const mensajes = []
    
    
    method ponerseVisible(){
        estaInvisible = false
    }
    
    method ponerseInvisible(){
        estaInvisible = true
    }
    
    method estaInvisible(){
        return estaInvisible
    }
    
    method desplegarMisiles(){
        misilesDesplegados = true
    }
    
    method replegarMisiles(){
        misilesDesplegados = false
    }
    
    method misilesDesplegados(){
        return misilesDesplegados
    }
    
    method emitirMensaje(mensaje){
        mensajes.add(mensaje)   
    }
       
    method mensajesEmitidos(){
        mensajes.size()	//or return mensajes
    }   
    
    method primerMensajeEmitido(){
        return mensajes.first()
    }
    
    method ultimoMensajeEmitido(){
        return mensajes.last()
    }
    
    method esEscueta(){
        return mensajes.all({elemento => elemento.size() < 30})
    }
    
    method emitioMensaje(mensaje){
        return mensajes.contains(mensaje)
    }
       
    override method prepararViaje(){
        super()
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en misión")
    }
    
    override method estaTranquila()= super() and not self.misilesDesplegados()
    
    override method escapar(){
    	self.acercarseUnPocoAlSol()
    	self.acercarseUnPocoAlSol()
    }
    
    override method avisar(){
    	self.emitirMensaje("Amenaza recibida")
    }
    
    override method relajo() = super() and self.esEscueta()
}

class NaveHospital inherits NaveDePasajeros{
    var estadoQuirofanos
    
    method estadoQuirofanos() = estadoQuirofanos
    
    method prepararQuirofanos(){
    	estadoQuirofanos = true
    }
    
    method quirofanosNoEstanListos(){
    	estadoQuirofanos = false
    }
    
    override method estaTranquila() = !self.estadoQuirofanos()
    override method recibirAmenaza(){
    	super()
    	self.prepararQuirofanos()
    }
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
    override method estaTranquila() = super() and !self.estaInvisible()
    
    override method recibirAmenaza(){
    	super()
    	self.desplegarMisiles()
    	self.ponerseInvisible()
    }
}