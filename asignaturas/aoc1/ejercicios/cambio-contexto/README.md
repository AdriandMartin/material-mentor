# Cambio de contexto
- Adián Martín &copy; 2022

________________________________________________________
## Enunciado

<div class="card bg-info">
<div class="card-header"> Notas sobre el problema </div>
<div class="card-body">

- Este problema, aunque sin entrar en ello, introduce el concepto de sistema multitarea. No obstante, solo pretende abordar cuál es la información que se debe guardar para evitar que el tratamiento de una interrupción tenga efectos colaterales en el programa interrumpido, pero planteándolo desde otro punto de vista.
- Los términos "rutina" y "programa" se utilizan indistintamente para referirse a un programa completo del usuario, con su rutina principal y sus posibles subrutinas (es decir, un programa como cualquier otro que hayáis podido implementar en las primeras prácticas de la asignatura).
</div>
</div>

Tras cursar la asignatura AOC1, decides comprar un computador con un microcontrolador LPC2105 (el mismo que se simula con Keil en las prácticas). Al enterarse de ello, dos de tus compañeros te piden utilizarlo para ejecutar sus códigos; el primero quiere probar en él su rutina *foo*, mientras que el segundo quiere hacer lo propio con su rutina *bar*. El código de ambos puede ejecutarse en modo usuario, al no requerir de operaciones privilegiadas ni de acceso al hardware (la funcionalidad particular que implemente cada rutina es irrelevante para este problema). No obstante, al disponer el *SoC* de un único core, te das cuenta de que solo podrás lanzar una de las dos rutinas cada vez.

Como los dos son tus amigos y no quieres que ninguno se quede sin ejecutar su código, decides plantear la siguiente solución: durante 0.1 segundos, ejecutarás el código de la rutina *foo*, pero después de ese tiempo, pasarás a ejecutar la rutina *bar*, y cuando pasen los siguientes 0.1 segundos volverás a poner en ejecución la rutina *foo*...es decir, cada 0.1 segundos, dejarás de ejecutar la rutina que hasta entonces haya tenido la CPU para pasar a ejecutar la otra. Al ejecutarse las rutinas alternadamente en un periodo tan pequeño de tiempo, dará la sensación de que los dos programas se están ejecutando simultáneamente, aunque en realidad solo uno de ellos estará utilizando la CPU en cada momento. El siguiente diagrama puede ayudar a visualizarlo mejor:

![Diagrama explicativo](images/explanation.svg)

Para medir el tiempo que se ejecuta cada rutina usarás el *timer0* del microcontrolador, que con la configuración de las prácticas provoca una interrupción cada centésima de segundo. Así, cada 10 interrupciones del *timer*, cambiarás la rutina que se ejecuta, logrando el efecto deseado.

Dada la situación expuesta, se plantean las siguientes preguntas:
1. ¿Qué información de la rutina *foo* se necesita guardar antes de poner en ejecución la rutina *bar*? ¿Y de la rutina *bar* antes de volver a ejecutar la rutina *foo*?
    
    <button data-bs-toggle="collapse" data-bs-target="#respuesta1">Mostrar solución</button>
    <div id="respuesta1" class="collapse">

    ### Respuesta propuesta

    Las consideraciones a tener en cuenta, en ambos casos, son las mismas que cuando se quiere que la atención de una interrupción no altere la ejecución del programa interrumpido; deberá salvarse el contenido de aquellos registros que vayan a ser modificados:
    - De entrada, eso incluye a todos los registros de propósito específico (*r11* -*frame pointer*-, *r13* -*stack pointer*-, *r14* -*link register*-, *r15* -*program counter*- y *cpsr* -*current program status register*-), pues es seguro que pueden verse alterados y su valor es crucial para el correcto funcionamiento de la rutina detenida.
    - En cuanto a los registros de propósito general, hay que tener en cuenta que, en el momento en el que se detiene la rutina, algunos de ellos contienen valores que es necesario salvar para que el código interrumpido pueda reanudar su ejecución sin ver afectado su resultado. Al no saber qué registros de propósito general está usando la rutina detenida, y al tener que poner en ejecución otro programa distinto que puede alterar el contenido de cualquiera de ellos, será necesario salvar todos los registros de propósito general que hay (*r0* a *r10* y *r12*).

    Por lo tanto, será necesario guardar el contenido de todo el banco de registros antes de pasar a ejecutar la otra rutina, y restaurarlo antes de reanudarla.

    A toda esa información de bajo nivel que define el estado de la ejecución de una rutina se le llama *contexto hardware*. Para poder reanudar la ejecución de una rutina y que ésta funcione de forma transparente al hecho de haberla detenido, se debe restaurar su contexto hardware antes de volver a cederle la CPU.

    </div>

2. En base a la respuesta de la primera pregunta, ¿se te ocurre alguna forma de reducir el espacio utilizado en memoria? ¿qué necesitarías saber?
   
   <button data-bs-toggle="collapse" data-bs-target="#respuesta2">Mostrar solución</button>
    <div id="respuesta2" class="collapse">

    ### Respuesta propuesta

    A costa de perder generalidad en la solución, podrían salvarse solo aquellos registros de propósito general que esté utilizando la rutina que se detiene. No obstante, hacer esto supone tener que reescribir el código del cambio de contexto cada vez que se modifique alguna de las rutinas a permutar, pues puede que tras los cambios necesite más o menos registros que en la versión inicial. En cuanto a los registros de propósito específico, siempre deberán ser salvados, por lo que no hay optimización posible para ellos.

    </div>
