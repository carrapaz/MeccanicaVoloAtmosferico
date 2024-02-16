### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 43b35f35-5d9c-4fc2-b778-e356cad72978
begin
	using 
		Plots,
	 	PlutoUI,
	 	Rotations,
	 	LaTeXStrings
	
	gr()
	print("Dependencies")
end

# ╔═╡ 38b8bf30-b673-11ee-0868-8df22983dbe9
md"""

# Meccanica del volo atmosferico

## Davide Viganò

### 28/1/24

"""

# ╔═╡ 51934362-4b1f-4aea-bcf3-a3a892de83a1
md"""
# Intro
Questo notebook interattivo è progettato per essere una risorsa nello studio della meccanica del volo atmosferico. È destinato a coloro che desiderano approfondire la comprensione del funzionamento del volo atmosferico, ed analizzare come specifici elementi di design dell'aeromobile influenzino le sue prestazioni in volo.
"""

# ╔═╡ 258dcb67-de1f-48b6-978f-86ba4603b244
md"""
# Ipotesi con cui lavoriamo

**Modelli del Velivolo** $br Nella rappresentazione matematica del problema è possibile scegliere diversi tipi di modellazione in base alla quantità di informazioni che si vuole ricavare.

1) Punto materiale "orientato" $3 G.D.L$ + sistema di riferimento

- le forze aerodinamiche dipendono dall'orientamento del velivolo stesso

- le distribuzioni di forze e masse perdono di significato

2) Velivolo come corpo rigido nello spazio $6 G.D.L$ (3 lin. + 3 rot.)

- equilibrio

- stabilità

- controllo

3) Mezzo modello $3 G.D.L.$ (2 lin. 1 rot.)

- verticale, longitudinale, beccheggio

- si trascura laterodirezionale

4) Modello flessibile, non affrontato nel corso

- Aeroelasticità


**Modello della Terra** $br La Terra viene considerata:
- Piatta
- Non rotante
Queste assunzioni comportano:
- Campo gravitazionale costante e uniforme. 
- Traiettorie a quota costante sono rettilinee
- Terra è sistema di riferimento inerziale

**Atmosfera standard:**

| Simbolo     | Grandezza | unità | aria standard |
| ----------- | ----------- | ----- | ---- |
| $h$      | quota       | $m$ | $11km$ |
| $\rho$      | densità       | $kg/m^3$| $1.215 kg/m^3$ |
| $T$      | temperatura     | $K$| $288.15K$ |
| $P$      | pressione    | $Pa$| $101.3kPa$ |
| $R$      | cost. gas     | $KJ/kgK$| $287.1KJ/kgK$|
| $g$      | cost. grav    | $m/s^2$| $9.81 m/s^2$ |
| $\lambda$      | coeff T/h    | $K/km$| $-6.5K/km$|


*ipotesi di gas perfetto:* $P=\rho*R*T$

*ipotesi di gas in quiete:* $\dfrac{dP}{dh}=-\rho*g$

usando queste ipotesi si possono ricavare $T$,$P$,$\rho$ in funzione di $h$

$$T(h)=
\begin{cases}
T(h) = T_0 + \lambda*h \ | \ h<h_s\\
T(h) = T_s \ | \ h>h_s
\end{cases}$$

con $T_s=216.5K$

$$P(h)=
\begin{cases}
P(h) = P_0 (1+\dfrac{\lambda h}{T_0})^\dfrac{-g}{R\lambda} \ | \ h<h_s\\
P(h) = P_s*e^{\dfrac{-g}{RT_s}(h-h_s)} \ | \ h>h_s
\end{cases}$$
\
la quota $h$ è misurata tramite differenziale di pressione rispetto a questi riferimenti

| Acronimo     | Riferimento | Utilizzo |
| ----------- | ----------- | ----- | 
| $QNH$      | pressione al livello del mare locale | volo a bassa quota o manovre terminali |
| $QNE$      | pressione standard $P_0$       | separazione tra varie rotte in crociera | 
| $QFE$      | lettura pressione aeroporto     | atterraggio (in parziale disuso)| 


"""

# ╔═╡ 3ea80b56-a7c7-4dd1-aae3-e240e0042145
md"""
# Richiami di cinematica
"""

# ╔═╡ 8e429280-d45f-4aaa-8db6-bb865822def4
md"""
con $\bar r$ si indica il vettore posizione in un generico sistema di riferimento questo è in funzione del tempo come variabile indipendente
"""

# ╔═╡ ce9842db-1d24-43dc-8d23-6964719c80a2
md"""
quindi la velocità e l'accellerazione possono essere scritte come:

$$
\begin{cases}
\bar r(t) = posizione\\
\dot{\bar r}(t) = velocità\\
\ddot{\bar r}(t) = accellerazione\\
\end{cases}$$
"""

# ╔═╡ e4f7b60f-7c55-462c-9ced-da14638b66ae
md"""
anzichè usare il tempo come variabile possiamo usare l' ascissa curvilinea, $S$, ossia lo spostamento del punto $P$ lungo la sua traiettoria
"""

# ╔═╡ c1e6d919-f3c6-4ae0-ad6c-eb6e22b82d3d
md"tempo: $(@bind time1 Slider(0:0.01:10, default=5,show_value=true))  s"

# ╔═╡ 659b9467-0144-4aa5-ba2e-ff76182ee87b
md"""
per esempio, nel caso di un aeromobile in 3 dimensioni si avrà:
"""

# ╔═╡ b79ae4e0-96fb-478e-8fc8-3316c6e394ce
md"tempo: $(@bind time2 Slider(0:0.01:10, default=5,show_value=true))  s"

# ╔═╡ c339e1dd-5889-46c7-874b-e6cc048a39bc
md"""
## Terna intrinseca di Frenet
"""

# ╔═╡ 69e84cbe-b7e4-48c5-a819-3f471f4d091c
md"""
la terna di Frenet è composta da tre versori:

**versore tangente:** 

$\hat e_t = \bar r'(S)$

la distanza perscorsa sarà:

$\Delta S = \int_{S0}^{S1} dS = \int_{t0}^{t1} \dot {\bar r}(t)dt$

quindi lo spostamento infinitesimo

$dS= \dfrac{|d \bar r|}{|d t|}*dt$
$dS= |d \bar r|$
$\dfrac{dS}{|d \bar r|}=1$

quindi

$\dfrac{d\bar r}{d S}=\bar r'(S)$

**versore normale:** 

$\hat e_n = R*\bar r''(S)$

Dove $R$ è il raggio di curvatura

$R=\dfrac{1}{|\bar r''(S)|}$

**versore binormale:**

$\hat e_b = \hat e_t \wedge \hat e_n$

"""

# ╔═╡ bc13b7b3-7fc4-4007-9025-2597005fa63a
md"S: $(@bind S1 Slider(0:0.01:10, default=5,show_value=true))"

# ╔═╡ 5890b370-d1b9-4372-b429-e2d902a98085
md"""
### Velocità e accellerazione
\
**Velocità:** $\dot{\bar r} =\dot S*\hat e_t$

$\dot{\bar r} = \dfrac{d \bar r}{dt} = \dfrac{d \bar r(S)}{dS} * \dfrac{dS}{dt} = \bar r'(S)* \dot S(t)=\dot S * \bar r' = \dot S*\hat e_t$

la veocità è sempre tangente alla traiettoria 
\
\
\
**Accellerazione:** $\ddot{\bar r} =\ddot S*\hat e_t+\dfrac{\dot S^2}{R}*\hat e_n$

dove $\ddot S*\hat e_t$ è la componente tangenziale e $\dfrac{\dot S^2}{R}*\hat e_n$ la componente normale dell'accellerazione.
$\omega = \dfrac{\dot S}{R}$ è la velocità angolare
"""

# ╔═╡ cfb0dd04-abd4-497d-8ed6-1c5e6c3a0ee4
md"""

# Sistemi di riferimento

"""

# ╔═╡ 45661987-c61e-4864-97a6-ac0ac6010d39
md"""
## Quota di volo
Distanza verticale tra velivolo e la superficie terrestre, può essere indicata come: 

- Quota assoluta, **absolute altitude:** $AA$ misurata rispetto alla topografia del terreno è utile per voli a bassa quota

- Quota vera, **true altitude** $TA$ misurata rispetto al livello medio del mare è utile per confrontare la distanza verticale tra velivoli in volo
"""

# ╔═╡ 82e5b6b0-def9-46ce-9e1e-8bf25a54b24e
md"S: $(@bind S2 Slider(0:0.01:7, default=5,show_value=true))"

# ╔═╡ 041459bb-0fad-4ed5-87f9-0c873ae7cfaa
md"""
## Fixed Earth frame $F_E$
chiamato anche navigational frame. è solidale alla Terra e inerziale.
fornisce una buona approssimazione per voli a bassa quota e di breve raggio.
Si può usare come origine la posizione definita da latitudine e longitudine.
Il piano di volo è tangente alla terra nella posizione.

la terna è così definita:
$$F_E=
\begin{cases}
\hat x_E, \hat y_E = versori \ piano\\
\hat z_E = normale \ al \ piano \ e \ discorde \ rispetto\ \bar g\\
origine = p(latitudine,longitudine)
\end{cases}$$


"""

# ╔═╡ bb575fbf-c996-4557-8b08-cc28db9c0db4
md"longitudine: $(@bind longitude Slider(-pi/2:0.1:2*pi-pi/2, default=-pi/4))"

# ╔═╡ 7df38388-286b-4767-8bc6-e56cfdb1f656
md"latitudine: $(@bind latitude Slider(-pi/2:0.1:pi/2, default=0))"

# ╔═╡ 8934ba0d-dbf5-4ef7-9733-530dcd42ef05
md"""
### Velocità al suolo in $F_E$
"""

# ╔═╡ 9ab15e4e-75d8-4fdf-ad53-8dfde7615a95
md"""
Spesso durante il volo la velocità rispetto al suolo **ground speed:** $\bar v_{GS}$ non coincide con la velocità con cui l'aereo viaggia nell'aria. questo perchè può esserci vento e l'aria stessa avere una velocità **wind speed:** $\bar v_W$. ciò comporta che l'aereo ha anche una velocità rispetto al vento $\bar v_{W^*}=- \bar v_{W}$ e la velocita di volo sarà la somma di queste due componenti **air speed:** $\bar v_{AS}=\bar v_{W^*}+\bar v_{GS}$

quindi per trovare la $\bar v_{GS}$ che in $F_E$ corrisponde a $\dot{\bar r}_E$ ossia la derivata nel tempo del vettore posizione nel sistema $F_E$ basta fare $\bar v_{GS}=\bar v_{AS}-\bar v_{W^*}$

la velocità in contesto areonautico è spesso misurata in nodi $Kn$ che sono definiti come miglia nautiche all'ora $\dfrac{mn}{h}$ con $1mn=1852m$
"""

# ╔═╡ 90e78e30-90f6-48cd-b699-3493cd662713
md"rotazione aereo: $(@bind rotazione1 Slider(0:0.01:2*pi, default=pi/2))"

# ╔═╡ 4ed72bd1-6fea-4a90-ae20-b23300f63085
md"velocità al suolo: $(@bind Vgs Slider(0:0.01:0.5, default=0.25))"

# ╔═╡ d3e9ee9d-fcdc-4eab-908a-19301fe18a0a
md"""
## Horizon frame $F_H$
"""

# ╔═╡ f053e0cb-ea7d-43a7-97cf-a90d7d6fa3d4
md"""
Anche chiamato NED (North,East,Down) o "terrestre mobile". Questo sistema di riferimento ha come origine un punto materiale sul velivolo per esempio il suo baricentro (center of gravity) $CG$. con $H$ indiciamo il piano dell'orizzonte.

la terna è così definita:
$$F_H=
\begin{cases}
\hat x_H = Nord\\
\hat y_H = East\\
\hat z_H = normale \ a \ H \ e \ concorde \ a\ \bar g\\
origine = CG \ velivolo
\end{cases}$$

da notare che la terna è indipendente rispetto l'asetto di volo in quanto definita rispetto alla terra
"""

# ╔═╡ ed65d686-ebaf-4cf4-a779-0283fd36583c
md"""
### Angoli di traiettoria
Definiscono il moto del velivolo rispetto alla Terra 
- **Angolo di rampa:** 
$\gamma=-sin^{-1}(\hat e_t*\hat z_H)$
- **Angolo di rotta:**
$\chi=tan^{-1}(\dfrac{\bar v*\hat y_H}{\bar v* \hat x_H})$
"""

# ╔═╡ 9350c9d1-f4cd-4633-8513-50ac1a9311ef
md"angolo di rampa $\gamma$: $(@bind gamma1 Slider(-360:1:360, default=20, show_value=true)) °"

# ╔═╡ 31437c3c-a21a-4301-9efd-de00c86a0e2e
md"angolo di rotta $\chi$: $(@bind chi1 Slider(-360:1:360, default=55,show_value=true)) °"

# ╔═╡ f1b15f3f-60a4-4605-953b-f4393a2de8a2
md" modulo della velocità $v$: $(@bind vh1 Slider(0:0.01:1, default=1,show_value=true))"

# ╔═╡ 49f7985f-e7f4-4cae-bbe3-c1821489c76c
md"""
### Velocità in $F_H$
La $\bar v$ può essere scomposta nelle velocità lungo i tre versori che definiscono la base del sistema $F_H$ possono essere così definite:

- velocità verticale:
$v_v= |\bar v|*sin(\gamma)$  
- velocità sul piano $H$:
$v_H=|\bar v|*cos(\gamma)$
- velocità verso Nord:
$v_{NH}=v_H*cos(\chi)$
- velocità verso Est:
$v_{EH}=v_H*sin(\chi)$
"""

# ╔═╡ 42038324-7780-4b84-a0de-2f36cf30212b
md"angolo di rampa $\gamma$: $(@bind gamma2 Slider(-360:1:360, default=35, show_value=true)) °"

# ╔═╡ d6ef6fcb-ee92-4d71-a0b4-5d25befaa16f
md"angolo di rotta $\chi$: $(@bind chi2 Slider(-360:1:360, default=55,show_value=true)) °"

# ╔═╡ 8c312483-ec4d-4c1d-a88a-626f7715928a
let
	vh2 = 1
	g = deg2rad(gamma2)
	c = deg2rad(chi2)
	
	# speeds
	vH=vh2*cos(g)
	vv=vh2*sin(g)
	vNH=vH*sin(c)
	vEH=vH*cos(c)
	
	# climb rate speed
	pg = plot(aspect_ratio=:equal, xlims=(-1, 1), ylims=(-1, 1),showaxis=false,legendfont=font(12),legend=:topleft)
	# N
	pg = plot!([-0.05,0.05],[-0.05,0.05], c=:red,label=L"\hat x_H",linewidth=3)
	pg = plot!([0.05,-0.05],[-0.05,0.05], c=:red,label="",linewidth=3)
	# E
	pg = plot!([0, 1], [0, 0], arrow=true, color=:green, label=L"\hat y_H",linewidth=2)
	# D
	pg = plot!([0, 0], [0, -1], arrow=true, color=:blue, label=L"\hat z_H",linewidth=2)
	# v
	pg = plot!([0, vH], [0, vv], arrow=true, color=:purple, label=L"\bar v",linewidth=2)
	# vv
	pg = plot!([vH, vH], [0, vv], arrow=true, color=:coral, label=L"v_v",linewidth=2)
	# vH
	pg = plot!([0, vH], [0, 0], arrow=true, color=:brown, label=L"v_H",linewidth=2)

	
	
	# speed on plane,N,E
	pc = plot(aspect_ratio=:equal, xlims=(-1, 1), ylims=(-1, 1),showaxis=false,legendfont=font(12),legend=:topleft)
	# N
	pc = plot!([0, 0], [0, 1], arrow=true, color=:red, label=L"\hat x_H",linewidth=2)
	# E
	pc = plot!([0, 1], [0, 0], arrow=true, color=:green, label=L"\hat y_H",linewidth=2)
	# D
	pc=plot!([-0.05,0.05],[-0.05,0.05], c=:blue,label=L"\hat z_H",linewidth=3)
	pc=plot!([0.05,-0.05],[-0.05,0.05], c=:blue,label="",linewidth=3)
	# vH
	pc = plot!([0, vEH], [0, vNH], arrow=true, color=:brown, label=L"v_H",linewidth=2)
	# vN
	pc = plot!([0, 0], [0, vNH], arrow=true, color=:yellow, label=L"v_N",linewidth=3)
	# vH
	pc = plot!([0, vEH], [0, 0], arrow=true, color=:lime, label=L"v_E",linewidth=2)
	plot(pg, pc, layout = (1, 2))
end

# ╔═╡ 46d626ec-d721-468e-9129-7ae9334d7c05
md"""
possiamo riscrivere la velocità $\bar v$ sulla nuova base $F_H$ partendo dai vettori velocità:

$\bar v_v= -|\bar v|*sin(\gamma)*\hat z_H$  

$v_H=|\bar v|*cos(\gamma)$

$\bar v_{NH}=v_H*cos(\chi)*\hat x_H=|\bar v|*cos(\gamma)*cos(\chi)*\hat x_H$

$\bar v_{EH}=v_H*cos(\chi)*\hat y_H=|\bar v|*cos(\gamma)*sin(\chi)*\hat y_H$

$\bar v_{F_H}=\bar v_{NH}+\bar v_{EH}+\bar v_v$
$\downarrow$
$\bar v_{F_H}=|\bar v|*(cos(\gamma)*sin(\chi)*\hat x_H+cos(\gamma)*cos(\chi)*\hat y_H-sin(\gamma)*\hat z_H)$
$\downarrow$
$\bar v_{F_H}=|\bar v|*\begin{bmatrix}  cos(\gamma)*cos(\chi)\\\ cos(\gamma)*sin(\chi) \\\ -sin(\gamma) \end{bmatrix}$
"""

# ╔═╡ 0635e8b7-1ebc-4a28-94fc-da0796146b4e
md"""
Da cui possiamo definire la velocità angolare $\omega_{F_H}$:

$\omega_{F_H}=\sqrt{\dot \gamma^2+\dot \chi^2*cos^2(\gamma)}$
"""

# ╔═╡ 05ec308d-c9f9-4c17-b15d-ada5d0a64b89
md"""
## Body frame $F_B$
"""

# ╔═╡ 1c754b21-6a19-4752-9ec4-8e4bd37b73a0
md"""
Il sistema $F_B$ è solidale al velivolo, l'orgine si trova su un punto materiale, spesso conviene usare $CG$

la terna è così definita:
$$F_B=
\begin{cases}
\hat x_B = verso \ la \ prua \ (asse \ rollio \ |Roll|)\\ 
\hat y_B = verso \ ala \ destra \ (asse \ beccheggio \ |Pitch|)\\
\hat z_B = verso \ il \ ventre \ (asse \ imbardata \ |Yaw|)\\
origine = CG \ velivolo
\end{cases}$$
"""

# ╔═╡ 94c96468-411c-4e01-b2f1-88cff2b6169c
md"""
viene definito piano simmetrico materiale il piano generato da $\hat x_B\hat z_B$ lo indichiamo con $PSM$
"""

# ╔═╡ e8bbcc41-02b6-43d7-b842-21ddfa92b49b
md"""
### Angoli di assetto
Definiscono l'orientamento del velivolo rispetto a $F_H$

- **Angolo di imbardata (Heading) :**
$\psi=tan^{-1}(\dfrac{\hat x_B*\hat y_H}{\hat x_B*\hat x_H})$

- **Angolo di beccheggio (Pitch) :**
$\theta=-sin^{-1}(\hat x_B*\hat z_H)$

- **Angolo di rollio (Roll) :**
$\phi=sin^{-1}(\hat y_B*\hat z_H)$

Attenzione $\gamma \neq \ \theta$ perchè $\theta$ a diffrenza di $\gamma$ non dipende da $\bar v$ stesso vale per $\psi$ e $\chi$ come si può vedere qui sotto $\chi$ è rispetto al $\bar v_H$ metre $\psi$ rispetto a $\hat x_B$ vedremo più avanti che esiste un angolo chiamato **Angolo di deriva:** $\beta=\chi-\psi$ e solo se $\beta=0\rightarrow\chi=\psi$
"""

# ╔═╡ 4f1f40e4-0d53-41dd-a8bc-93c69a3e0c1b
md"angolo di imbardata $\psi$: $(@bind psi1 Slider(-360:1:360, default=35, show_value=true)) °"

# ╔═╡ 140eb5fe-d3c7-4c0e-bc2d-b7e377a953d5
md"angolo di beccheggio $\theta$: $(@bind theta1 Slider(-360:1:360, default=35, show_value=true)) °\
definito positivo a cabrare"

# ╔═╡ 0a9510c2-7b71-44d5-8223-9d398890a53b
md"angolo di rollio $\phi$: $(@bind phi1 Slider(-360:1:360, default=15, show_value=true)) °"

# ╔═╡ c53bc007-1f1e-41e7-a9c3-c71a0d6c63c1
md"""
### Angoli aereodinamici
Definiscono l'orientamento del velivolo rispetto al vento

- **Angolo di deriva (Side slip):**
$\beta=sin^{-1}(\dfrac{\bar v * \hat y_B}{|\bar v|})$ 

- **Angolo di incidenza (Attack angle):**
$\alpha=tan^{-1}(\dfrac{\bar v * \hat z_B}{\bar v*\hat x_B})$ 

Quindi $\beta$ è l'angolo tra $\bar v_{AS}$ e il $PSM$ mentre $\alpha$ è l'angolo tra la proiezione di $\bar v_{AS}$ su $PSM$ e $\hat x_B$

"""

# ╔═╡ afe62312-eff7-4c8d-8f9b-03b4a94eac40
md"angolo di deriva $\beta$: $(@bind beta1 Slider(-45:1:45, default=15, show_value=true)) °"

# ╔═╡ c55079d2-0bf7-4094-bcf8-8de86d0d001a
md"angolo di deriva $\beta$: $(@bind beta2 Slider(-45:1:45, default=35, show_value=true)) °"

# ╔═╡ 93b9b3a4-9493-4085-a73e-9b8c4be45b96
md"angolo di incidenza $\alpha$: $(@bind alpha2 Slider(-45:1:45, default=20, show_value=true)) °"

# ╔═╡ 65b12662-2f8f-4bea-aadf-d7791eb24ecd
md"""
### Velocità all'aria
La $\bar v_{AS}$ può essere scomposta nelle velocità lungo i tre versori chedefiniscono la base del sistema $F_B$ usando gli angoli aerodinamici:

$$\bar v_{F_B}=
\begin{cases}
\bar v_{AS}*\hat y_B = | \bar v_{AS}|*sin(\beta)\\
\bar v_{PSM} = | \bar v_{AS}|*cos(\beta)
\end{cases}$$

$\downarrow$

$$\bar v_{F_B}=
\begin{cases}
\bar v_{\hat x_B} = | \bar v_{AS}|*sin(\beta)*cos(\alpha) \\
\bar v_{\hat y_B} = | \bar v_{AS}|*sin(\beta) \\
\bar v_{\hat z_B} = | \bar v_{AS}|*cos(\beta)*sin(\alpha)
\end{cases}$$

\

Possiamo ora fare un paio di ipotesi nel caso degli aerei:

$$\begin{cases}
v_{\hat z_B}>>v_{\hat y_B} \ altrimenti \ moto \ laterale \\
v_{\hat x_B}>>v_{\hat z_B} \ altrimenti \ stallo
\end{cases}$$
$\downarrow$
$\bar v_{F_B} \approx \hat x_B \rightarrow \beta\approx\dfrac{v_{\hat y_B}}{|\bar v_{AS}|},\alpha\approx\dfrac{v_{\hat z_B}}{|\bar v_{AS}|}$

queste approssimazioni sono valide per $\alpha, \beta$ piccoli

"""

# ╔═╡ 86118dd3-99f7-4470-b9c1-ab5c8be001c3
md"""
## Aerodynamic frame $F_A$
Il sistema $F_A$ è usato per calcolare le forzanti aereodinamiche, l'orgine si trova in $CG$, viene definito a partire da $F_B$ tramite 2 rotazioni consecutive. La prima rotazione è di $-\alpha$ attorno a $\hat y_B$ che ci porta allo Stability Frame $F_S$ la seconda è di $\beta$ attorno a $\hat z_S$ che ci porta a $F_A$

la terna è così definita:
$$F_A=
\begin{cases}
\hat x_A = verso \ la \ \bar v_{AS}\\ 
\hat y_A = \hat x_B \wedge \hat z_A\\
\hat z_A = su \ PSM \ e \ normale \ a \ \hat x_A\\
origine = CG \ velivolo
\end{cases}$$

"""

# ╔═╡ 454992df-7cf2-439f-97a3-f47df6d4ce14
md"angolo $\alpha_{F_S}$: $(@bind asfi Slider(-45:1:45, default=0, show_value=true)) °"

# ╔═╡ 47e28d45-2a52-4a78-9970-efd6436a377e
md"angolo $\beta_{F_S}$: $(@bind bsfi Slider(-45:1:45, default=0, show_value=true)) °"

# ╔═╡ 4b0d29d1-43e3-4db7-a797-0ca2e08a51c0
md"""
# Classificazione dei regimi di volo
## Tipologie di volo comuni

- Uniforme: 
$|\dot{\bar v}|=0 \rightarrow |\bar v|=cost$

- Rettilineo: 
$R=\infty\rightarrow \omega=0 \rightarrow \dot\chi,\dot\gamma=0$

- Orizzontale:
$$\begin{cases}
\gamma=0 \\
\gamma>0 \ salita \\
\gamma<0 \ discesa
\end{cases}$$

- Nel piano verticale:
$\dot\chi=0\rightarrow
\omega = \dot\gamma$

- Simmetrico: 
$\beta=0\rightarrow\bar v_{AS}\in PSM$

- Livellato: 
$\phi=0$

- Simmetrico nel piano orizzontale:
$$\begin{cases}
\beta=0 \\
\gamma=0 \\
\omega=\dot\chi
\end{cases}$$

- Orizzontale rettilineo unifrome ($VORU$):
$$\begin{cases}
|\dot{\bar v}|=0 \\
R=\infty \\
\omega=\dot\chi
\end{cases}$$
"""

# ╔═╡ dc250eda-e9d9-437d-b549-2992973d9cf1
md"""
## Manovre curvilinee

- Richiamata (Pull-up):
$\dot\gamma>0$

- Affondata (Dive)
$\dot\gamma<0$

- Virata positiva, verso destra (Right turn):
$\dot\chi>0$

- Virata negativa, verso sinistra (Left turn):
$\dot\chi<0$

"""

# ╔═╡ ba58fd28-983b-4688-bd7c-14512fe63402
md" $\dot\gamma$: $(@bind dgamma1 Slider(-4:0.1:4, default=2, show_value=true)) °/s"

# ╔═╡ ebcb05ec-541e-40c5-9438-e5db68747541
md" $\dot\chi$: $(@bind dchi1 Slider(-4:0.1:4, default=2, show_value=true)) °/s"

# ╔═╡ a765006c-29fb-47cc-801e-d9cf62952091
md"""
# Elementi di Aereodinamica
## Equazioni cardinali
Notazione:
- Quantità di moto e momento qdm: $\bar Q$ , $\bar H$
- Forze e momenti aereodinamici: $\bar F$ , $\bar M$
- Forze e momenti dovuti alla propulsione: $\bar T$ , $\bar \Gamma$
- Forze e momenti dovuti al peso: $\bar W$ , $\bar\Sigma$

$$\begin{cases}
\dfrac{d\bar Q}{dt}=\bar F+\bar T+\bar W \\
\dfrac{d\bar H_P}{dt}=\bar M_P+\bar\Gamma_P+\bar\Sigma_P
\end{cases}$$

Il bilancio tramite le equazioni cardinali può essere svolto su un generico punto $P$, tuttavia se si utilizza $CG\rightarrow \bar\Sigma=0$

$$\begin{cases}
\dot{\bar Q}=\bar F+\bar T+\bar W \\
\dot{\bar H_G}=\bar M_G+\bar\Gamma_G
\end{cases}$$
 
"""

# ╔═╡ 18a37d1e-2ce2-4710-b429-788c559c31c3
md"""
## Forza aerodinamica

Un corpo immerso in un fluido subisce delle forze dovute a attriti viscosi e differenze di pressioni esercitate sulla superficie dello stesso. Queste possono generare momenti. Possiamo ricavarle facendo l'integrale chiuso sulla superficie del corpo per il contributo degli sforzi.

Con $\bar\tau$ indichiamo il tensore degli sforzi, con $P_0$ il punto di riduzione dei momenti, $Q$ è una posizione variabile all'interno del corpo, $\bar n$ il versore normale alla superficie e $\mu$ la viscosità del fluido

- Forza aerodinamica:
$\bar F=\oint{\bar\tau \ dS}$

- Momento rispetto al punto $P_0$:
$\bar M=\oint {\bar\tau \wedge(P-Q)*dS}$  

Dalle equazioni di Navier Stokes

$\bar\tau = -P\bar n -\dfrac{2}{3}\mu(\nabla\cdot\bar v)\bar n + 2\mu(\nabla\cdot\bar v)^T\bar n$

Ricaviamo un legame funzionale tra $\bar \tau$ e le grandezze che lo influenzano

$\bar\tau=\bar\tau(P,\bar v,\mu,\bar n)$

Possiamo ora passare al' **espressione funzionale della forza aerodinamica** $\bar F$

$\bar F = \bar F(P,\bar V,\mu,\bar n,S)$

dove $P,\bar V$ sono i valori della pressione e velocità locale e S la superficie, tuttavia sotto le nostre ipotesi di lavoro possiamo riscriverla in funzione dei valori del flusso indisturbato riducendo il numero di variabili:

Usando la legge dei gas perfetti $P=\rho*R*T$ 

$\bar F = \bar F(\rho_\infty,T_\infty,\mu_\infty,\bar V_\infty,\bar n,S)$

Usiamo ora la velocità del suono in un fluido $a=\sqrt{\rho RT}$

$\bar F = \bar F(\rho_\infty,a_\infty,\mu_\infty,\bar V_\infty,\bar n,S)$

Riscriviamo $\bar V_\infty$ con $F_A$ $\rightarrow \bar V_\infty=f(|\bar v_{AS}|,\alpha,\beta)$

$\bar F = \bar F(\rho_\infty,a_\infty,\mu_\infty,|\bar v_{AS}|,\alpha,\beta,\bar n,S)$

Quest'ultima è l' **Espressione funzionale della forza aerodinamica**


"""

# ╔═╡ 229ffa9f-145b-4fe1-b063-0ffb598bb918
md"""
## Teorema di Buckingham $(\pi)$

Ogni equazione fisica dipendente da $n$ variabili fisiche $[q_i]$ esprimibili intermini di K quantità fisiche fondamentali è rappresentabile come funzione di $n-K$
variabili adimensionali $\Pi_j$ costruite moltiplicando tra loro combinazioni delle
variabili fisiche originali

Vediamo ad esempio la forza aereodinamica:
- 5 variabili fisiche $\rightarrow \rho,|\bar v|,\mu,a,S$

- 3 grandezze fisiche fondamentali  $L, M, T$ (lunghezza,massa,tempo)
variabili adimensionali $\Pi_j=5-3=2$ 

- Raccogliamo in $K$ i restanti parametri adimensionali $K=K(\alpha,\beta,forma)$

scriviamo la relazione

$|\bar F|=K*\rho^{e_\rho}*a^{e_a}*\mu^{e_\mu}*V^{e_V}*S^{e_S}$

facciamo l'analisi dimensionale

$[MLT^{-2}]=[ML^{-3}]^{e_\rho}[LT^{-1}]^{e_a}[ML^{-1}T^{-1}]^{e_\mu}[LT^{-1}]^{e_V}[L^2]^{e_S}$

uguagliamo gli esponenti di $M,L,T$ per ricavare un sistema di equazioni

$$\begin{cases}
[M]\rightarrow 1 = e_\rho + e_\mu\\
[L]\rightarrow -2 = -3 e_\rho + e_a - e_{\mu}+e_V+2e_S\\
[T]\rightarrow -2=-e_a-e_\mu-e_V\\
\end{cases}$$

abbiamo 3 equazioni e 5 incognite, il sistema è sottodeterminato possiamo scriverlo tramite combinazioni lineari di 2 variabili, secondarie, scegliamo come variabili secondarie  $e_\mu,e_a$ e riscriviam il sistema

$$\begin{cases}
 e_\rho = 1 - e_\mu\\
 e_S = \dfrac{1}{2}(-2+3 e_\rho - e_a + e_{\mu}-e_V)\\
 e_V=2-e_a-e_\mu\\
\end{cases}$$
$\downarrow$
$$\begin{cases}
 e_\rho = 1 - e_\mu\\
 e_S = 1-\dfrac{1}{2}e_\mu\\
 e_V=2-e_a-e_\mu\\
\end{cases}$$

Riscriviamo $|\bar F|$ in funzione delle relazioni trovate

$|\bar F|=K*\rho^{1 - e_\mu}*a^{e_a}*\mu^{e_\mu}*V^{2-e_a-e_\mu}*S^{1-\dfrac{e_\mu}{2}}$

$\downarrow$

$|\bar F|=K \rho V^{2} S (\dfrac{a}{V})^{e_a}  (\dfrac{\mu}{\rho V \sqrt{S}})^{e_\mu}$

Tra questi riconosciamo che $(\dfrac{\mu}{\rho V \sqrt{S}})$ è il numero di Reynolds invertito quindi $(\dfrac{\mu}{\rho V \sqrt{S}})=Re^{-1}$ mentre $\dfrac{a}{V}$ è il numero di Mach invertito quindi $Ma^{-1}=\dfrac{a}{V}$

Riscriviamo di nuovo $|\bar F|$ raccogliendo tutti i termini adimensionali in un unico coefficiente $C_F=C_F(\alpha,\beta,forma,Ma^{-e_a},Re^{-e_\mu})$

$|\bar F|=\dfrac{1}{2} \rho V^2  S C_F$

Questa è la formulazione tipica delle forze aerodinamiche quali lift e drag, che raccogliento i primi termini nella pressione dinamica $q_D$ diventa:

$|\bar F|=q_D S C_F$

La procedura è equivalente per i momenti aggiungendo $l$ lunghezza di riferimento si ottiene:

$|\bar M|=q_D l C_M$

Questa riscrittura è molto conveniente, avendo i due corpi di dimensioni diverse lo stesso $C_F,C_M$, è quindi sufficiente conoscere $q_D,S$ dell'areomobile vero per poter calcolare le forze che subirà in volo a partire dalle forze rilevate su un suo modello in galleria del vento
"""

# ╔═╡ 6a64478c-4a13-454e-a2fc-19e289638b44
md"""
## Definizioni per le forzanti aerodinamiche

Scomponiamo $\bar F$ e $\bar M_P$ rispetto ai sistemi di riferimento $F_A$ e $F_B$

- Scomposizione della forza aerodinamica $\bar F$ in $F_A$
$$\begin{cases}
D = -\hat x_A \cdot \bar F \rightarrow resistenza \rightarrow q_DSC_D=D
\\ Q = -\hat y_A \cdot \bar F \rightarrow devianza \rightarrow q_DSC_Q=Q
\\ L = -\hat z_A \cdot \bar F \rightarrow portanza \rightarrow q_DSC_L=L
\end{cases}$$

$\bar F= -(D\hat x_A+Q\hat y_A+L\hat z_A)=-q_DS(C_D\hat x_A+C_Q\hat y_A+C_L\hat z_A)$

- Scomposizione dei momenti aerodinamici $\bar M_P$ in $F_B$


$$\begin{cases}
 \mathcal{L}_P= \hat x_B \cdot \bar M_P \rightarrow momento \ di \ rollio \rightarrow q_DSbC_{\mathcal{L}_P}=\mathcal{L}_P

\\ \mathcal{M}_P= \hat y_B \cdot \bar M_P \rightarrow momento \ di \ beccheggio \rightarrow q_DS\bar cC_{\mathcal{M}_P}=\mathcal{M}_P

\\ \mathcal{N}_P= \hat z_B \cdot \bar M_P \rightarrow momento \ di \ imbardata \rightarrow q_DSbC_{\mathcal{N}_P}=\mathcal{N}_P
\\(b = apertura \ alare)(\bar c = corda \ aerodinamica \ media)
\end{cases}$$

$\bar M_P=\mathcal{L}_P\hat x_B+\mathcal{M}_P\hat y_B+\mathcal{N}_P \hat z_B$

- Scomposizione su assi corpo $\bar F$ in $F_B$
$$\begin{cases}
X = \hat x_B \cdot \bar F \rightarrow longitudinale \rightarrow X \approx -D + L\alpha
\\ Y = \hat y_B \cdot \bar F \rightarrow trasversale \rightarrow Y \approx -Q
\\ Z = \hat z_B \cdot \bar F \rightarrow verticale \rightarrow Z \approx -L
\\ approssimazioni \ valide \ per \ \alpha,\beta<<1 
\end{cases}$$

"""

# ╔═╡ 66ce96db-5d29-4761-b069-b885f224754b
md"""
## Analisi del profilo
"""

# ╔═╡ a1211f22-1f94-47fe-ae55-b5d06bb3000e
md"angolo di incidenza $\alpha$: $(@bind alpha3 Slider(-45:1:45, default=20, show_value=true)) °"

# ╔═╡ cb81651b-b845-4352-ac5b-6de837c81daa
md"""
$\begin{cases}
\bar F = -(L \hat x_A + D \hat z_A)\\
M = M_P \hat y_B\\
\end{cases}$

profili:

| Profilo    | $CL_0$ | $\alpha_0$ |
| ----------- | ----------- | ----- |
| $simmetrico$      | 0       | 0 | 
| $convesso$      | +       | - | 
| $concavo$      | -     | + | 

"""

# ╔═╡ b83382c0-6f94-430c-bce2-8963150dce48
md"""
# Diagrammi Penaund
"""

# ╔═╡ 3ad6fce1-fb0e-446a-b724-81af756eecb3
let

	# Dati aereo
	W = 440440
	S = 91
	Td = 30631
	
	# Coefficienti Polare
	cd0 = 0.019
	k = 0.0425
	
	# Dati volo
	rho = 0.423
	V_s = 115.2
	V_m = 133.7
	V_t = 154.5
	L = W

	# Funzioni
	V = V_s:1:400
	
	CL(V) = 2 .* L ./ (rho .* S .* V .^2)
	
	CD(CL) = cd0 .+ k .* CL .^ 2
	
	D(V) = 0.5 .* rho .* S .* V .^ 2 .* CD.(CL.(V))

	# Grafico
	plot(V, D.(V),
		label="Drag vs. Velocity",
		xlabel="Velocity (m/s)",
		ylabel="Drag (N)",
		legend=:bottomright
	)
	
	plot!(V, fill(Td,length(V)), lab="T_d = $Td")
	plot!([V_s,V_s],[0,D.(V_s)], lab="Vs= $V_s")
	plot!([V_m,V_m],[0,D.(V_m)], lab="Vm= $V_m")
	plot!([V_t,V_t],[0,D.(V_t)], lab="Vt= $V_t")

	D_t = D(V_t)
	plot!([V_s-10,V_t],[D.(V_t),D.(V_t)], lab=D_t)
	
	#print(D_t)
	#q = 0.5 * rho * V_t^2  * S 
	#CD_t = D_t/q

	#phi = acosd((k^0.5*W)/(q*sqrt(D_t/q - cd0)))
end

# ╔═╡ 4187da49-e658-4ec6-9e6b-dbeefc086173
let

	# Dati aereo
	W = 440440
	S = 91
	Td = 30631
	
	# Coefficienti Polare
	cd0 = 0.019
	k = 0.0425
	
	# Dati volo
	rho = 0.423
	V_s = 115.2
	V_m = 133.7
	V_t = 154.5
	L = W

	# Funzioni
	V = V_s:1:400
	
	CL(V) = 2 .* L ./ (rho .* S .* V .^2)
	
	CD(CL) = cd0 .+ k .* CL .^ 2
	
	D(V) = 0.5 .* rho .* S .* V .^ 2 .* CD.(CL.(V))

	P(V) = D.(CD.(CL.(V))) .* V
	
	# Grafico
	plot(V, P.(V),
		label="Potenza  Velocità",
		xlabel="Velocità (m/s)",
		ylabel="Potenza (W)",
		legend=:bottomright
	)
	
	#plot!(V, fill(Td ,length(V)), lab="T_d = $Td")
	plot!([V_s,V_s],[0,P.(V_s)], lab="Vs= $V_s")
	plot!([V_m,V_m],[0,P.(V_m)], lab="Vm= $V_m")
	plot!([V_t,V_t],[0,P.(V_t)], lab="Vt= $V_t")

	P_t = D(V_t) .* V
	plot!([V_s-10,V_t],[P.(V_t),P.(V_t)], lab=P_t)
	
	#print(D_t)
end

# ╔═╡ b2f6bec4-449a-4299-8cda-4f7645627728
md"""
# Esercizi
"""

# ╔═╡ 6bb79929-043e-426c-885f-b62647bf5279
md"""
## Esercitazione 1
Esercitazione su equilibrio e stabilità
"""

# ╔═╡ ed1c4634-14db-457b-86b9-c1cb5829b927
md"""
### ES 1
Determinare $\alpha$ e $W$ tali da avere equilibrio per $V_{EAS}=125m/s$ e $\delta_E = 1.7°$

	# legame costitutivo
	CL(a,d) = CL_a .* a + CL_d .* d + CL0
	CM(a,d) = CM_a .* a + CM_d .* d + CM0
	
	# Dati
	S = 87
	delta = deg2rad(1.7)
	
	# Coefficienti Portanza
	CL_a = 5.65
	CL_d = 0.38
	CL0 = -0.12
	
	# Coefficienti Momento
	CM_a = -0.82
	CM_d = -1.61
	CM0 = 0.128
\

ricavare $\alpha$ imponendo $CM_{CG} = 0$

$\alpha = - \dfrac{CM_{/\delta} \delta_E + CM_0}{CM_{/ \alpha}}$

poi ricavo $W = L = \dfrac{1}{2} \rho_0 V_{EAS}^2 S CL$

"""

# ╔═╡ 6d3df4f8-6f48-4aba-ac2f-6b4d50470522
let
	# legame costitutivo
	CL(a,d) = CL_a .* a + CL_d .* d + CL0
	CM(a,d) = CM_a .* a + CM_d .* d + CM0
	
	# Dati
	S = 87
	delta = deg2rad(1.7)
	
	# Coefficienti Portanza
	CL_a = 5.65
	CL_d = 0.38
	CL0 = -0.12
	
	# Coefficienti Momento
	CM_a = -0.82
	CM_d = -1.61
	CM0 = 0.128

	# Calcoli
	alpha = - (CM_d*delta+CM0)/CM_a
	W = 0.5*1.225*125^2*87*CL(alpha,delta)
	
	# Risultati
	ES1_1 = [rad2deg(alpha),W]

	begin
		print("alpha = $(ES1_1[1]) \n")
		print("W = $(ES1_1[2]) \n")
	end
	
end

# ╔═╡ 1aee1451-5479-4110-b181-3a5ec856841f
md"""
### ES 2
Determinare $\xi_{CG}$ tale da avere margine statico = 16%

	# Dati
	Sw = 87
	St = 19.25
	ms = 0.16
	
	# CL^w/alpha (ala) e CL^t/alpha (coda)
	aw = 4.7
	at = 3.32
	
	# Posizioni adimensionalizzate
	ACw = -0.038
	ACt = -4.8
	
	# Coefficienti ala -> coda 
	epsilon_alpha = 0.35
	eta = 0.95
	sigma = St/Sw

$margine \ statico = \xi_{CG}-\xi_{N} = 0.16$

$\xi_{CG}=0.16 +\xi_{N}$

$CM_{P / \alpha}=(\xi_{AC}^w-\xi_{P})a^w+\eta \sigma (1- \epsilon_{/ \alpha})(\xi_{AC}^t-\xi_{P})a^t$

tuttavia se $P = N \rightarrow CM_{P / \alpha}=0$

$0=(\xi_{AC}^w-\xi_{N})a^w+\eta \sigma (1- \epsilon_{/ \alpha})(\xi_{AC}^t-\xi_{N})a^t$

$\downarrow$

$\xi_N=\dfrac{\xi_{AC}^w *a^w + \eta \sigma (1- \epsilon_{/ \alpha})\xi_{AC}^t*a^t}{ a^w + \eta \sigma (1- \epsilon_{/ \alpha})a^t}$

$\xi_{CG}=0.16+\xi_{N}$
"""

# ╔═╡ 9d7935b8-c73b-474d-af5a-891266ead65c
let
	
	# Dati
	Sw = 87
	St = 19.25
	ms = 0.16
	
	# CL^w/alpha (ala) e CL^t/alpha (coda)
	aw = 4.7
	at = 3.32
	
	# Posizioni adimensionalizzate
	ACw = -0.038
	ACt = -4.8
	
	# Coefficienti ala -> coda 
	epsilon_alpha = 0.35
	eta = 0.95
	sigma = St/Sw
	
	# Calcoli
	N = (ACw * aw + eta * sigma * ACt * (1-epsilon_alpha) * at)/(aw + eta * sigma*(1-epsilon_alpha)*at)

	CG = 0.16 + N
	
	
	# Risultati
	ES1_2 = [N,CG]

	begin
		print("xi N = $(ES1_2[1]) \n")
		print("xi CG = $(ES1_2[2]) \n")
	end
	
end

# ╔═╡ 922102af-abb4-4905-91ef-e4a16c2ea6f7
md"""
# Temi di esame
"""

# ╔═╡ 2465f157-287f-4d24-84ad-bfc48b6e814f
md"""
## TDE 24/01/2023
"""

# ╔═╡ af97f9d3-b2d3-4576-8729-6d72a6a5db1f
md"""
### ES 1
"""

# ╔═╡ 73f59f92-f3d7-4372-a863-33978479a984
md"""
## TDE 29/6/2011
"""

# ╔═╡ b05df4d0-dbdd-4f65-90d3-c8fae9430900
md"""
### ES 1
"""

# ╔═╡ 10783065-3c6e-47a1-bccb-5675b3573563
let
	# dati isa
	rho0 = 1.225
	R = 287.05
	theta0 = 288.15
	g = 9.81
	lam_isa = -0.0065
	h = 5000
	
	# Formule isa
	T(rho2,T0) = (rho2/rho0)*T0
	rhoh = (1+h*lam_isa/theta0)^(-(1+g/(R*lam_isa)))*rho0 
	ht(rhot) = theta0/lam_isa*((rhot/rhoh)^((R*lam_isa)/(g+R*lam_isa))-1)

		
	# Dati aereo
	S = 93
	W = S*4170
	b = 28.6
	e = 0.86
	lam = b^2/S
	CLmax = 1.62
	
	# Coefficienti Polare
	cd0 = 0.019
	k = 1/(pi*e*lam)
	
	# Dati volo
	L = W
	rho = rhoh
	V_s = sqrt(2*L/(rhoh*S*CLmax))
	V_m = 93

	# Calcoli volo
	# Spinte
	q = 0.5*S*rho*V_m^2
	qs = 0.5*S*rho*V_s^2
	
	Td = q*cd0 + k * L^2/q
	Trs = qs*cd0 + k * L^2/qs

	deltapot= Td-Trs

	# Salita rapida
	#V_v = sqrt(Td/(3*rho*S*cd0)*(1+sqrt(1+3*((2*cd0)/Td)^2)))
	V_v = sqrt((rho*S*Td + sqrt((rho*S*Td)^2+4*k*W^2*(3*rho^2*S^2)*cd0))/(3*(rho*S)^2*cd0))

	# Funzioni
	V = V_s:1:400
	
	CL(V) = 2 .* L ./ (rho .* S .* V .^2)
	
	CD(CL) = cd0 .+ k .* CL .^ 2
	
	D(V) = 0.5 .* rho .* S .* V .^ 2 .* CD.(CL.(V))

	# seconda parte
	
	CLvv= CL(V_v)
	
	qv = 0.5*S*rho*V_v^2
	Tv = qv*cd0 + k * L^2/qv
	
	vv=(Td*V_v-Tv*V_v)/W

	gammav = asind(vv/V_v)

	h = 

	global ES1_290611=[k,rhoh,V_s,Td,deltapot,V_v,CLvv,vv, gammav]
	
	# Grafico
	plot(V, D.(V),
		label="Drag vs. Velocity",
		xlabel="Velocity (m/s)",
		ylabel="Drag (N)",
		legend=:bottomright
	)
	
	plot!(V, fill(Td,length(V)), lab="T_d = $Td")
	plot!(V, fill(Tv,length(V)), lab="T_v = $Tv")
	plot!([V_s,V_s],[0,D.(V_s)], lab="Vs= $V_s")
	plot!([V_m,V_m],[0,D.(V_m)], lab="Vm= $V_m")

end

# ╔═╡ b525969a-c0c5-4471-b0e7-9d3f3b829819
begin
	print("k = $(ES1_290611[1]) \n")
	print("rhoh = $(ES1_290611[2]) \n")
	print("v stallo = $(ES1_290611[3]) \n")
	print("trazione disponibile = $(ES1_290611[4]) \n")
	print("delta trazione richiesta stallo = $(ES1_290611[5]) \n")
	print("Vv salita rapida = $(ES1_290611[6]) \n")
	print("CL salita rapida = $(ES1_290611[7]) \n")
	print("velocità verticale = $(ES1_290611[8]) \n")
	print("gamma v = $(ES1_290611[9]) \n")
end

# ╔═╡ 7c8954f2-fa31-4d1a-90ca-575dccf2db07
md"""
### ES 2
Si consideri un velivolo di architettura tradizionale caratterizzato dai seguenti dati:

	# Dati
	Sw = 98
	St = 16.7
	ms = 0.12
	
	# CL^w/alpha (ala) e CL^t/alpha (coda)
	aw = 4.85
	at = 4.11
	
	# Posizioni adimensionalizzate
	ACw = -0.041
	CG = -0.281
	
	# Coefficienti ala -> coda 
	epsilon_alpha = 0.33
	eta = 0.98
	sigma = St/Sw

Si assume che l'asse longitudinale sia orientato verso la prua, che la lunghezza di riferimento sia la
corda media aerodinamica dell'ala (MAC) e che il centro aerodinamico del piano orizzontale
coicida col punto di controllo.
Si determini la posizione del piano orizzontale (ossia quella del suo centro aerodinamico) che
permette di ottenere una condizione stabile con un margine statico del 12% e la pendenza della
curva di portanza trimmata. Quali dovrebbero essere la posizione del baricentro ed il margine
statico perché tale pendenza aumenti del 4%?

$margine \ statico = \xi_{CG}-\xi_{N} = 0.12$

$\xi_{N}=\xi_{CG}-0.12 = -0.401$

$CM_{P / \alpha}=(\xi_{AC}^w-\xi_{P})a^w+\eta \sigma (1- \epsilon_{/ \alpha})(\xi_{AC}^t-\xi_{P})a^t$

tuttavia se $P = N \rightarrow CM_{P / \alpha}=0$

$0=(\xi_{AC}^w-\xi_{N})a^w+\eta \sigma (1- \epsilon_{/ \alpha})(\xi_{AC}^t-\xi_{N})a^t$

$\downarrow$

$\xi_{AC}^t=\xi_{N}-\dfrac{(\xi_{AC}^w-\xi_{N})a^w}{ \eta \sigma (1- \epsilon_{/ \alpha})a^t}=-4.198$

per la pendenza della polare trimmata:

$\epsilon = \dfrac{e}{d} = \dfrac{\xi_{CG} - \xi_{N}}{\xi_{N}-\xi_{C}}=0.0316$

$CL_{/\alpha} = a^w + \eta  \sigma  (1-\epsilon_\alpha)*a^t = 5.147$

$CL_{/ \alpha}^*= CL_{/ \alpha}* (\dfrac{1}{1+\epsilon})$

Per il nuovo $ms$ e $CG$ bisogna ricordarsi che lo spostamento in avanti del baricentro causa una diminuzione della pendenza della retta $CL_{/ \alpha}$

quindi:

$1.04 * CL_{/ \alpha}^*= CL_{/ \alpha}* (\dfrac{1}{1+\epsilon_2})$

ricavo per $\epsilon_2$:

$\epsilon_2= \dfrac{CL_{/ \alpha}}{1.04*CL_{/ \alpha}^*}-1$

$ms2= (\dfrac{CL_{/ \alpha}}{1.04*CL_{/ \alpha}^*}-1)*d = -3\%$

ora si può ricavare $\xi_{CG2} = ms2+\xi_N=-0.432$

"""

# ╔═╡ 988be133-a521-4afc-9919-ab65fef8e512
md"""
# Codice del notebook
"""

# ╔═╡ f6717f17-30c4-49bd-abf2-623dd7f78d9d
PlutoUI.TableOfContents()

# ╔═╡ a9935d19-6ab2-4044-bc3e-07089e8801d5
begin
# Function to generate sphere coordinates
	function sphere(r, C, n)   # r: radius; C: center [cx,cy,cz]
	    u = range(-π, π; length = n)
	    v = range(0, π; length = n)
	    x = C[1] .+ r*cos.(u) * sin.(v)'
	    y = C[2] .+ r*sin.(u) * sin.(v)'
	    z = C[3] .+ r*ones(n) * cos.(v)'
    	return x, y, z
	end

	function plane_coords(latitude,longitude,radius,plane_size)
		# Calculate the normal vector at the intersection point
		normal_x = cos(latitude) * cos(longitude)
		normal_y = cos(latitude) * sin(longitude)
		normal_z = sin(latitude)
		
		# Tangent vectors at the intersection point
		tangent_vector_θ = [-sin(latitude) * cos(longitude), -sin(latitude) * sin(longitude), cos(latitude)]
		tangent_vector_φ = [-sin(longitude), cos(longitude), 0]
		
		# Define the range for the plane coordinates
		u_range = LinRange(-plane_size, plane_size, 2)
		v_range = LinRange(-plane_size, plane_size, 2)
	
		# Create the grid for the plane using the tangent vectors
		x_plane = [normal_x * radius + u * tangent_vector_θ[1] + v * tangent_vector_φ[1] for u in u_range, v in v_range]
		y_plane = [normal_y * radius + u * tangent_vector_θ[2] + v * tangent_vector_φ[2] for u in u_range, v in v_range]
		z_plane = [normal_z * radius + u * tangent_vector_θ[3] + v * tangent_vector_φ[3] for u in u_range, v in v_range]

		return x_plane,y_plane,z_plane
	end

	function parallel_coords(radius,n_points,latitude)
		# Parallel (constant latitude)
		parallel_range = LinRange(0, 2π, n_points)
		parallel_x = radius * cos.(parallel_range) * cos(latitude)
		parallel_y = radius * sin.(parallel_range) * cos(latitude)
		parallel_z = ones(n_points) * radius * sin(latitude)
		return parallel_x,parallel_y,parallel_z
	end
	function meridian_coords(radius,n_points,longitude)
		# Meridian (constant longitude)
		meridian_range = LinRange(0, π, n_points)
		meridian_x = radius * sin.(meridian_range) * cos(longitude)
		meridian_y = radius * sin.(meridian_range) * sin(longitude)
		meridian_z = radius * cos.(meridian_range)
		return meridian_x,meridian_y,meridian_z
	end
	
	print("Funzioni per FE")
end

# ╔═╡ 4c58ff04-6f48-4247-8bbb-7a9593432368
let
	
	# Generate the sphere coordinates
	radius = 10
	n_points = 100
	

	# Generate coordinates of plane tangent to the sphere
	
	plane_size = radius * 0.2 # This is an arbitrary size for visualization
	x_plane,y_plane,z_plane = plane_coords(latitude,longitude,radius,plane_size)
	
	# Generate parallel (latitude) and meridian (longitude)
	
	parallel_x,parallel_y,parallel_z = parallel_coords(radius,n_points,latitude)
	
	meridian_x,meridian_y,meridian_z = meridian_coords(radius,n_points,longitude)
	
	# Coordinates of the intersection point (at the equator and prime meridian)
	intersection_x = radius * cos(latitude) * cos(longitude)
	intersection_y = radius * cos(latitude) * sin(longitude)
	intersection_z = radius * sin(latitude)

	
	# Plotting

	ptr = plot()
	# Plot the sphere
	#surface(x_sphere, y_sphere, z_sphere, color=:blue, alpha=0.5, legend=false,label=true)
	surface(sphere(radius, [0,0,0],n_points),c=:blue,colorbar=false)

	# Plotting the parallel and meridian
	plot!(parallel_x, parallel_y, parallel_z, linewidth=4, color=:red)
	plot!(meridian_x, meridian_y, meridian_z, linewidth=4, color=:green)

	# Plotting the tangent plane
	plot!(x_plane, y_plane, z_plane,st=:surface, c=:yellow, alpha=1,legend=false)
	
	# Plotting the intersection point
	scatter!([intersection_x], [intersection_y], [intersection_z], color=:black, markersize=3, label="P")

	xlimFE=[-radius-plane_size,+radius+plane_size]
	ylimFE=[-radius-plane_size,+radius+plane_size]
	zlimFE=[-radius-plane_size,+radius+plane_size]
	xaxis!(xlim=xlimFE)
	yaxis!(ylim=ylimFE)
	zaxis!(ylim=ylimFE)
	title!(L"Fixed Earth frame $F_E$",showaxis=false)
	
	scatter!([0 0], [-1 NaN -1 NaN -1 NaN -1], lims=(0,1),
    inset=(1,bbox(0.05,0.1,0.15,0.15)), subplot=2, msw=0, marker=:square,
    legendfontsize=12, framestyle=:none, fg_color_legend=nothing, legend=:left,
    color=[:red :white :green :white :black :white :yellow], label=" "^2 .* ["latitudine" "" "longitudine" "" "posizione" "" "piano"])
		
end

# ╔═╡ 68b98a8b-da00-4678-9de2-26f329e7226a
begin
	
	# Define a side view airplane shape as a list of vertices
	function airplane_shape_side()
	    # Coordinates for a more realistic top-down airplane shape
	    fuselage = [
	        (-0.03, -0.02), (0.09, -0.02), (0.15, 0), (0.09, 0.02), (-0.03, 0.02), # Fuselage and nose (a pentagon shape)
	        (-0.15, 0.003), (-0.15, -0.003), (-0.03, -0.02) # Back to start to close the shape
	    ]
	    
	    tail = [
	        (-0.12, 0.01), (-0.16, 0.05), (-0.14, 0.05), (-0.08, 0.01), # Top tail (a small triangle)
	        (-0.12, -0.01), (-0.14, -0.02), (-0.14, -0.02), (-0.03, -0.01) # Bottom tail (a small triangle)
	    ]
	
	    # Combine all parts of the airplane
	    return [Shape(fuselage), Shape(tail)]
	end
	
	# Define a top-down airplane shape as a list of vertices
	function airplane_shape()
	    # Coordinates for a more realistic top-down airplane shape
	    fuselage = [
	        (-0.04, -0.02), (0.08, -0.02), (0.14, 0), (0.08, 0.02), (-0.04, 0.02), # Fuselage and nose (a pentagon shape)
	        (-0.16, 0.003), (-0.16, -0.003), (-0.04, -0.02) # Back to start to close the shape
	    ]

	    wings = [
	        (-0.02, 0.02), (-0.07, 0.2), (-0.06, 0.2), (0.04, 0.02), # Right wing (a diamond shape)
	        (-0.02, -0.02), (-0.07, -0.2), (-0.06, -0.2), (0.04, -0.02), # Left wing (a diamond shape)
	    ]
	    
	    tail = [
	        (-0.16, 0.01), (-0.2, 0.05), (-0.18, 0.05), (-0.12, 0.01), # Top tail (a small triangle)
	        (-0.16, -0.01), (-0.2, -0.05), (-0.18, -0.05), (-0.12, -0.01) # Bottom tail (a small triangle)
	    ]
	
	    # Combine all parts of the airplane
	    return [Shape(fuselage), Shape(wings), Shape(tail)]
	end

	# Define a behind view airplane shape as parametric functions
	function airplane_shape_back()
	    # we use only circles bcs we lazy af
		t=range(-pi,pi,40)
		
		# body
		xb(t) = cos(t)
		yb(t) = sin(t)
	    fuselage = Shape(xb.(t),yb.(t))

	    # wings
		xw(t) = 6*cos(t)
		yw(t) = 0.1*sin(t)-0.7
	    wings = Shape(xw.(t),yw.(t))

		# tail
		xt(t) = 0.1cos(t)
		yt(t) = 1.5*sin(t)+1
	    tail = Shape(xt.(t),yt.(t))

		# elevron
		xe(t) = 3*cos(t)
		ye(t) = 0.1*sin(t)+0.5
	    elevron = Shape(xe.(t),ye.(t))
		
	
	    # Combine all parts of the airplane
	    return [fuselage, wings, tail, elevron]
	end

	function NACA_shape(naca)
		num_points=100
	    m = parse(Int, naca[1]) ./ 100.0  # maximum camber
	    p = parse(Int, naca[2]) ./ 10.0   # location of maximum camber
	    t = parse(Int, naca[3:end]) ./ 100.0  # maximum thickness
	
	    c = 1.0  # chord length
	    x = collect(range(0, stop=c, length=num_points))
	
	    # Thickness distribution
	    yt = t ./ 0.2 .* c .* (0.2969 .* sqrt.(x ./ c) .- 0.1260*(x/c) .- 0.3516 .* (x ./ c) .^ 2 .+ 0.2843 .* (x./c).^3 .- 0.1015 .* (x ./ c) .^4)
	
	    # Mean camber line
	    yc = zeros(num_points)
	    for i in 1:num_points
	        if x[i] < p.*c
	            yc[i] = m./(p.^2).*(2 .* p .* (x[i] ./ c) .- (x[i] ./ c) .^2)
	        else
	            yc[i] = m./((1 .-p).^2).*((1 .-2 .* p) .+ 2 .* p .* (x[i] ./ c) .- (x[i]./c).^2)
	        end
	    end
	
	    # Calculate upper and lower surface coordinates
	    theta = atan.(m./(p^2) * (2 .*p .- 2 .*(x/c)))
	    xu = x .- yt .* sin.(theta)
	    yu = yc .+ yt .* cos.(theta)
	    xl = x .+ yt .* sin.(theta)
	    yl = yc .- yt .* cos.(theta)
	
		Upper = Shape(xu,yu)
		Lower = Shape(xl,yl)
    return [Upper, Lower]
end

	
	function rotate_all(parts,angle)	
		rotated_parts = [Plots.rotate(part,angle,(0,0)) for part in parts]
		return rotated_parts
	end
	
	function scale_all(parts,scale)	
		rotated_parts = [Plots.scale(part,scale[1],scale[2],(0,0)) for part in parts]
		return rotated_parts
	end

	function translate_all(parts,dxdy)	
		translated_parts = [translate(part,dxdy[1],dxdy[2]) for part in parts]
		return translated_parts
	end

	function transform_all(parts,dxdy,scale,angle)
		transformed = rotate_all(parts,angle)
		transformed = scale_all(transformed,scale)
		transformed = translate_all(transformed,dxdy)
		return transformed
	end

	print("funzioni Disegna e muovi aereo 2D")
end

# ╔═╡ d44fb526-84b6-4c13-aace-7ffa36a861b1
let	
	# Plotting
	plt = plot(aspect_ratio=:equal, xlims=(-0.5, 0.5), ylims=(-0.5, 0.5),showaxis=false,legendfont=font(12))
	airplane = transform_all(airplane_shape(),[0,0],[1,1],rotazione1)
	plot!(airplane,c=:black,label="")

	# Define a translation vector (dx, dy)
	dx, dy = 0, 0
	
	# Plotting the speeds
	# Ground speed
	plot!(aspect_ratio=:equal, xlims=(-0.5, 0.5), ylims=(-0.5, 0.5))
	plot!([dx, dx+Vgs*cos(rotazione1)], [dy, dy+Vgs*sin(rotazione1)], arrow=true, color=:blue, label=L"v_{GS}",linewidth=2)
	# Wind speed
	plot!([dx, 0.1], [dy, 0.1], arrow=true, color=:purple, label=L"v_{W^*}",linewidth=2)
	# Air speed
	plot!([dx, 0.1+Vgs*cos(rotazione1)], [dy, 0.1+Vgs*sin(rotazione1)], arrow=true, color=:red, label=L"v_{AS}",linewidth=2)
	# Connectors
	plot!([0.1, 0.1+Vgs*cos(rotazione1)], [0.1, 0.1+Vgs*sin(rotazione1)], color=:gray, label="",linewidth=1,line=:dash)
	plot!([dx+Vgs*cos(rotazione1), 0.1+Vgs*cos(rotazione1)], [dy+Vgs*sin(rotazione1), 0.1+Vgs*sin(rotazione1)], color=:gray, label="",linewidth=1, line=:dash)
	
end

# ╔═╡ 337267df-a02d-4163-8bac-98ddd734ea18
let
	# Plotting
	plt = plot(aspect_ratio=:equal, xlims=(-0.5, 0.5), ylims=(-0.5, 0.5),showaxis=false,legendfont=font(12),legend=:topleft)
	airplane = transform_all(airplane_shape(),[0,0],[1,1],2/3*pi)
	plot!(airplane,c=:black,label="")
	# N
	plot!([0, 0], [0, 0.4], arrow=true, color=:red, label=L"\hat x_H",linewidth=2)
	# E
	plot!([0, 0.4], [0, 0], arrow=true, color=:green, label=L"\hat y_H",linewidth=2)
	# D
	plot!([-0.05,0.05],[-0.05,0.05], c=:blue,label=L"\hat z_H",linewidth=3)
	plot!([0.05,-0.05],[-0.05,0.05], c=:blue,label="",linewidth=3)
end

# ╔═╡ b5fe8375-2d01-44e6-9b1d-718009dba565
let
	# Top view
	pt = plot(aspect_ratio=:equal,
		xlims=(-1, 1),
		ylims=(-1, 1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft
	)
	airplane = transform_all(airplane_shape(),[0,0],[4,4],pi/2)
	pt = plot!(airplane,c=:black,label="")
	
	# xB
	pt = plot!([0, 0], [0, 1], arrow=true, color=:red, label=L"\hat x_B",linewidth=2)
	# yB
	pt = plot!([0, 1], [0, 0], arrow=true, color=:green, label=L"\hat y_B",linewidth=2)
	# zB
	pt = plot!([-0.05,0.05],[-0.05,0.05], c=:blue,label=L"\hat z_B",linewidth=3)
	pt = plot!([0.05,-0.05],[-0.05,0.05], c=:blue,label="",linewidth=3)

	# Side view
	ps = plot(aspect_ratio=:equal,
		xlims=(-1, 1),
		ylims=(-1, 1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft
	)
	airplane = transform_all(airplane_shape_side(),[0,0],[4,4],0)
	ps = plot!(airplane,c=:black,label="")
	
	# xB
	ps = plot!([0, 1], [0, 0], arrow=true, color=:red, label=L"\hat x_B",linewidth=2)
	# zB
	ps = plot!([0, 0], [0, -1], arrow=true, color=:blue, label=L"\hat z_B",linewidth=2)
	# yB
	ps= scatter!([0,0],[0,0], c=:green,label=L"\hat z_H",markersize=10)

	plot(pt, ps, layout = (1, 2))
end

# ╔═╡ a47a670f-db88-477c-8eb1-561e5b3fdf27
"""
Crea grafico comparazioni differenze quote \\
S: parametro funzioni
"""
function Quota_di_volo(S2)
	# Plotting
	plt = plot(aspect_ratio=:equal, xlims=(0, 10), ylims=(-0.5, 2),legendfont=font(12),legend=:bottomright)
	airplane = transform_all(airplane_shape_side(),[S2,1.5],3*[1,1],0)
	plot!(airplane,c=:black,label="")

	# Plotting with transformed parts
	#plot_airplane_parts(transformed_airplane_parts)
	x = range(0, 10, length=100)
	terrain(x) =  sin(x)/(x+1)
	sea(x) = 0*x
	plot!(sea,color=:blue, label="mare")
 	plot!(terrain,color=:green, label="terreno")
	plot!([S2+0.1, S2+0.1], [1.5, terrain(S2)], arrow=true, color=:green, label=L"AA")
	plot!([S2-0.1, S2-0.1], [1.5, sea(S2)], arrow=true, color=:blue, label=L"TA")
	return plt
end

# ╔═╡ a679ab80-4fbb-4e10-845a-bb9ca338bc69
Quota_di_volo(S2)

# ╔═╡ 14c78908-06ae-4636-a7eb-ac387c759e8a
"""
Crea una predefinita traiettoria parametrica in 2d e i vettori tangenti e normali alla fine di essa
S: parametro funzione
"""
function traiettoria_parametrica_2d(S1)
	# Define the range and parametric functions
	t = range(0, S1, length=100)
	x(t) = t
	y(t) = sin(t)
	dx(t) = 1
	dy(t) = cos(t)
	d2x(t) = 0
	d2y(t) = -sin(t)
	
	# Generate coordinates for the curve
	x_coords = x.(t)
	y_coords = y.(t)
	
	# Choose the point t0 at the end of the range
	t0 = S1
	x0, y0 = x(t0), y(t0)
	dx0, dy0 = dx(t0), dy(t0)
	d2x0, d2y0 = d2x(t0), d2y(t0)
	
	# Compute tangent and normal vectors
	magnitude_tangent = sqrt(dx0^2 + dy0^2)
	tx, ty = dx0 / magnitude_tangent, dy0 / magnitude_tangent
	nx, ny = -ty * sign(d2y0), tx * sign(d2y0)
	return x_coords,y_coords,x0,y0,tx,ty,nx,ny
end

# ╔═╡ f66827da-440b-4b91-a085-063a9bcfad57
let
	x_coords,y_coords=traiettoria_parametrica_2d(time1)
	
	plot(x_coords, y_coords, label=L"S", xlabel="x(t)", ylabel="y(t)", title="Traiettoria Parametrica",xlim=[0,10],ylim=[-1,1],legendfont=font(14),legend=:topright)
	plot!( [0, x_coords[end]], [0, y_coords[end]], arrow=true, color=:red, label=L"\bar r")
end

# ╔═╡ 52942653-05c3-4eaa-bf3e-f594a089bd1c
let
	
	x_coords,y_coords,x0,y0,tx,ty,nx,ny=traiettoria_parametrica_2d(S1)
	
	# Plot the trajectory and vectors
	p = plot(x_coords, y_coords, label=L"S", xlabel="x(S)", ylabel="y(S)", xlims=[0,10], ylims=[-2,2], title="Traiettoria Parametrica",aspect_ratio=:equal,legendfont=font(14),legend=:topright)
	plot!(p, [0, x_coords[end]], [0, y_coords[end]], arrow=true, color=:red, label=L"\bar r")
	plot!(p, [x0, x0+tx], [y0, y0+ty], arrow=true, color=:blue, label=L"\hat e_t")
	plot!(p, [x0, x0+nx], [y0, y0+ny], arrow=true, color=:green, label=L"\hat e_n")

end

# ╔═╡ 14e7a4a4-b209-401c-845a-bc199851195a
"""
Crea una predefinita traiettoria parametrica in 3d  \\
S: parametro funzione
"""
function traiettoria_parametrica_3d(S1)
	# Define the range and parametric functions
	t = range(0, S1, length=100);

	x(t) = cos(t);
    y(t) = sin(t);
	z(t) = t;
	
	x_coords = x.(t);
	y_coords = y.(t);
	z_coords = z.(t);
	
	return x_coords,y_coords,z_coords
end


# ╔═╡ c1fc80bc-c3aa-4f2e-bc53-6cb770964a87
let
	x_coords,y_coords,z_coords=traiettoria_parametrica_3d(time2)
	
	p = plot(x_coords, y_coords, z_coords, label=L"S",legendfont=font(14),legend=:topright)
	plot!( [0, x_coords[end]], [0, y_coords[end]],[0, z_coords[end]], arrow=true, color=:red, label=L"\bar r",xlims=[-1,1],ylims=[-1,1],zlims=[0,10])
	
end

# ╔═╡ f00df351-e2da-4886-947c-95a0f684c13e
"""
Crea una predefinita traiettoria parametrica in 3d  \\
R: raggio manovra
"""
function manovre_curvilinee(R)
	# Define the range and parametric functions
	t = range(-pi, pi, length=360)
	x(t) = (1/R)*cos(t)
	y(t) = (1/R)*sin(t)
	
	# Generate coordinates for the curve
	x_coords = x.(t)
	y_coords = y.(t)
	
	return x_coords,y_coords
end


# ╔═╡ 5777b4ce-2eac-44ec-ab14-cf06d6577065
let
	# Top view
	pt = plot(
		aspect_ratio=:equal,
		xlims=(-1, 1),
		ylims=(-1, 1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft
	)
	
	airplane = transform_all(airplane_shape(),[0,0],[1,1],pi/2)
	pt = plot!(airplane,c=:black,label="")

	if dchi1==0
		ydc= (-10:0.1:10)
		xdc= zeros(201)
	else
		xdc,ydc=manovre_curvilinee(dchi1)
		xdc=xdc .- 1/dchi1
	end
	
	pt = plot!(-xdc*4,ydc*4,lab="")
	
	# Side view
	ps = plot(
		aspect_ratio=:equal,
		xlims=(-1, 1),
		ylims=(-1, 1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft
	)
	
	airplane = transform_all(airplane_shape_side(),[0,0],[1,1],0)
	ps = plot!(airplane,c=:black,label="")

	
	
	if dgamma1==0
		xdg= (-10:0.1:10)
		ydg= zeros(201)
	else
		xdg,ydg=manovre_curvilinee(dgamma1)
		ydg=ydg .- 1/dgamma1
	end
	
	
	ps= plot!(xdg*4,-ydg*4,lab="")

	plot(pt, ps, layout = (1, 2))
end

# ╔═╡ 6123f526-a9f1-41d7-8499-09e56465f9e0
"""
Crea cordinate per un arco orizzontale in 3d \\
radius: raggio arco \\
ini: punto inizio in radianti \\
fin: punto fine in radianti \\
n_points: numero di punti sull'arco \\
latitude: altezza dell'arco rispetto piano orizzontale origine
"""
function harc3d(radius,ini,fin,n_points,latitude)
		# Parallel (constant latitude)
		range = LinRange(ini, fin, n_points)
		x = radius * cos.(range) * cos(latitude)
		y = radius * sin.(range) * cos(latitude)
		z = radius * ones(n_points) * sin(latitude)
		return x,y,z
	end

# ╔═╡ 6b07a0d6-5c00-49f4-9d0c-ad2f9bb5e3ac
"""
Crea cordinate per un arco verticale in 3d \\
radius: raggio arco \\
ini: punto inizio in radianti \\
fin: punto fine in radianti \\
n_points: numero di punti sull'arco \\
longitude: rotazione dell'arco rispetto asse verticale
"""
function varc3d(radius,ini,fin,n_points,longitude)
		# Meridian (constant longitude)
		range = LinRange(ini, fin, n_points)
		x = radius * sin.(range) * cos(longitude)
		y = radius * sin.(range) * sin(longitude)
		z = radius * cos.(range)
		return x,y,z
	end

# ╔═╡ d8c80578-7c6a-41f6-ab49-e33ee4fbdd9b
let
	# frame of reference
	plot(
		title="Angoli di traiettoria",
		showaxis=false,
		legendfont=font(12),
		xlim=[-1,1],
		ylim=[-1,1],
		zlim=[-1,1],
		legend=:topleft)
	plot!([0,1],[0,0],[0,0],c=:green, lab=L"\hat y_H",lw=2)
	plot!([0,0],[0,1],[0,0],c=:red, lab=L"\hat x_H",lw=2)
	plot!([0,0],[0,0],[0,-1],c=:blue, lab=L"\hat z_H",lw=2)
	
	# define velocity as function of gamma and chi
	v = vh1*[cosd(gamma1)*cosd(chi1),cosd(gamma1)*sind(chi1),sind(gamma1)]
	

	# plane projections
	# z_h
	plot!([v[2],v[2]],[v[1],v[1]],[v[3],0],c=:orange, lab="",lw=1,l=:dash)
	# y_h
	plot!([v[2],v[2]],[0,v[1]],[0,0],c=:grey, lab="",lw=1,l=:dash)
	# x_h
	plot!([0,v[2]],[v[1],v[1]],[0,0],c=:grey, lab="",lw=1,l=:dash)
	# piano x_h,y_h
	plot!([0,v[2]],[0,v[1]],[0,0],c=:grey, lab="",lw=1,l=:dash)

	# angles
	# chi
	chi_x,chi_y,chi_z = harc3d(sqrt(v[2]^2+v[1]^2),pi/2,pi/2-deg2rad(chi1),40,0)
	plot!(chi_x, chi_y, chi_z, lw=3, c=:cyan,lab=L"\chi")
	# gamma
	gamma_x,gamma_y,gamma_z = varc3d(sqrt(v[2]^2+v[1]^2),pi/2,pi/2-deg2rad(gamma1),40,pi/2-deg2rad(chi1))
	plot!(gamma_x, gamma_y, gamma_z, lw=3, c=:orange,lab=L"\gamma")
	
	# velocity vector
	plot!([0,v[2]],[0,v[1]],[0,v[3]],c=:purple, lab=L"\bar v",lw=2)
end

# ╔═╡ 5aeef1e9-f16b-43f3-b7be-d083e15c70c7
"""
Crea cordinate per un arco in 3d \\
radius: raggio arco \\
ini: punto inizio in radianti \\
fin: punto fine in radianti \\
n_points: numero di punti sull'arco \\
longitude: rotazione dell'arco rispetto asse verticale
"""
function arc3d(α,β,γ,r,ain,afin)
	M(u) = [r*cos(u), r*sin(u), 0]    # arc in X-Y plane
	RM(u) = RotXYZ(α,β,γ) * M(u) .+ C     # rotated + shifted arc in 3D
	
	C = [0, 0, 0]               # center of arc
	u = LinRange(ain, afin, 72)
	xs, ys, zs = [[p[i] for p in RM.(u)] for i in 1:3]
	return xs,ys,zs
end

# ╔═╡ 69424d76-9aa9-4be2-8e90-514824645980
let
	a = deg2rad(alpha2)
	b = deg2rad(beta2)
	vh1  = 1
	# frame of reference
	plot(
		title="Angoli aerodinamici",
		showaxis=false,
		legendfont=font(12),
		xlim=[-1,1],
		ylim=[-1,1],
		zlim=[-1,1],
		legend=:topleft)
	# body axis
	plot!([0,1],[0,0],[0,0],c=:green, lab=L"\hat y_B",lw=2)
	plot!([0,0],[0,1],[0,0],c=:red, lab=L"\hat x_B",lw=2)
	plot!([0,0],[0,0],[0,-1],c=:blue, lab=L"\hat z_B",lw=2)
	
	# define velocity as function of beta and alpha
	v = vh1*[cos(a)*cos(b),sin(b),cos(b)*sin(a)]
	
	# plane projections
	# z_B
	plot!([v[2],v[2]],[v[1],v[1]],[0,v[3]],c=:grey, lab="",lw=1,l=:dash)
	# x_By_B
	plot!([0,v[2]],[0,v[1]],[0,0],c=:grey, lab="",lw=1,l=:dash)
	# x_B,z_B
	plot!([0,v[2]],[v[1],v[1]],[v[3],v[3]],c=:grey, lab="",lw=1,l=:dash)
	# piano x_B,z_B
	plot!([0,0],[0,cos(a)],[0,sin(a)],c=:grey, lab="",lw=1,l=:dash)
	# v su piano x_B,z_B
	plot!([0,0],[0,v[1]],[0,v[3]],c=:brown, lab=L"\bar v_{PSM}",lw=2)

	# angles
	# beta
	b_x,b_y,b_z = arc3d(a,0,0,1,pi/2,pi/2-b)
	plot!(b_x, b_y, b_z, lw=3, c=:purple2,lab=L"\beta")
	# alpha
	a_x,a_y,a_z = varc3d(1,pi/2,pi/2-a,40,pi/2)
	plot!(a_x, a_y, a_z, lw=3, c=:orange3,lab=L"\alpha")
	
	# velocity vector
	plot!([0,v[2]],[0,v[1]],[0,v[3]],c=:purple, lab=L"\bar v_{AS}",lw=2)
end

# ╔═╡ 8c7a0753-17f0-41e8-8349-28c2d309cade
let
	a = deg2rad(14)
	b = deg2rad(27)
	asf = deg2rad(asfi)
	bsf = deg2rad(bsfi)
	vh1  = 1
	# frame of reference
	plot(
		title=L"Prova \ ad \ allineare \ F_A",
		showaxis=false,
		legendfont=font(12),
		xlim=[-1,1],
		ylim=[-1,1],
		zlim=[-1,1],
		legend=:topleft)
	# body axis
	plot!([0,1],[0,0],[0,0],c=:green, lab=L"\hat y_B",lw=1,l=:dot)
	plot!([0,0],[0,1],[0,0],c=:red, lab=L"\hat x_B",lw=1,l=:dot)
	plot!([0,0],[0,0],[0,-1],c=:blue, lab=L"\hat z_B",lw=1,l=:dot)

	# body axis
	plot!([0,cos(bsf)],[0,-cos(asf)*sin(bsf)],[0,-sin(asf)*sin(bsf)],c=:green, lab=L"\hat y_S",lw=3)
	plot!([0,sin(bsf)],[0,cos(asf)*cos(bsf)],[0,sin(asf)*cos(bsf)],c=:red, lab=L"\hat x_S",lw=3)
	plot!([0,0],[0,sin(asf)],[0,-cos(asf)],c=:blue, lab=L"\hat z_S",lw=3)
	
	# define velocity as function of beta and alpha
	v = vh1*[cos(a)*cos(b),sin(b),cos(b)*sin(a)]
	
	# plane projections
	# z_B
	plot!([v[2],v[2]],[v[1],v[1]],[0,v[3]],c=:grey, lab="",lw=1,l=:dash)
	# x_By_B
	plot!([0,v[2]],[0,v[1]],[0,0],c=:grey, lab="",lw=1,l=:dash)
	# x_B,z_B
	plot!([0,v[2]],[v[1],v[1]],[v[3],v[3]],c=:grey, lab="",lw=1,l=:dash)
	# piano x_B,z_B
	plot!([0,0],[0,cos(a)],[0,sin(a)],c=:grey, lab="",lw=1,l=:dash)
	# v su piano x_B,z_B
	plot!([0,0],[0,v[1]],[0,v[3]],c=:brown, lab=L"\bar v_{PSM}",lw=1)

	# angles
	# beta
	b_x,b_y,b_z = arc3d(a,0,0,1,pi/2,pi/2-b)
	plot!(b_x, b_y, b_z, lw=1, c=:purple2,lab=L"\beta=27^°")
	# alpha
	a_x,a_y,a_z = varc3d(1,pi/2,pi/2-a,40,pi/2)
	plot!(a_x, a_y, a_z, lw=1, c=:orange3,lab=L"\alpha=14^°")
	
	# velocity vector
	plot!([0,v[2]],[0,v[1]],[0,v[3]],c=:purple, lab=L"\bar v_{AS}",lw=1)
end

# ╔═╡ 36737977-5a27-45f3-a0ce-84c1badd4dce
"""
Crea cordinate per un cerchio in 2d \\
radius: raggio arco \\
ini: punto inizio in radianti \\
fin: punto fine in radianti \\
n_points: numero di punti sull'arco
"""
function par2dcircle(r,n_points,ini,fin)
	t = LinRange(ini,fin,n_points)
	x(t) = r*sin(t)
	y(t) = r*cos(t)

	x_coord=x.(t)
	y_coord=y.(t)

	return x_coord,y_coord
end

# ╔═╡ 43e6a216-fbc3-4b91-ac5e-144f60152e35
let
	psi = deg2rad(psi1)
	
	# Top view
	plot(aspect_ratio=:equal,
		xlims=(-1,1),
		ylims=(-1,1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft,
		title=L"Angolo \ di \ imbardata \ \psi"
	)
	airplane = transform_all(airplane_shape(),[0,0],[4,4],-psi+pi/2)
	plot!(airplane,c=:black,label="")

	# N
	plot!([0, 0], [0, 1], arrow=true, c=:red, lab=L"\hat x_H",lw=1,l=:dot)
	# E
	plot!([0, 1], [0, 0], arrow=true, c=:green, lab=L"\hat y_H",lw=1,l=:dot)
	# D
	plot!([-0.05,0.05],[-0.05,0.05], c=:blue,lab=L"\hat z_H",lw=2,l=:dot)
	plot!([0.05,-0.05],[-0.05,0.05], c=:blue,lab="",lw=2, l =:dot)
	
	# xB
	plot!([0, sin(psi)], [0, cos(psi)], arrow=true, c=:red, lab=L"\hat x_B",lw=2)
	# yB
	plot!([0, cos(psi)], [0, -sin(psi)], arrow=true, c=:green, lab=L"\hat y_B",lw=2)
	# zB
	plot!([-0.05,0.05],[-0.05,0.05], c=:blue,lab=L"\hat z_B",lw=3)
	plot!([0.05,-0.05],[-0.05,0.05], c=:blue,lab="",lw=3)

	# psi
	xpsi,ypsi=par2dcircle(1,40,0,psi)
	plot!(xpsi,ypsi,arrow=true,label=L"\psi",lw=3, c=:fuchsia)
	
	# v
	plot!([0, sin(psi+0.2)], [0, cos(psi+0.2)], arrow=true, c=:brown, lab=L"\bar v_H",lw=1,l=:dot)

	# chi
	xchi,ychi=par2dcircle(0.8,40,0,psi+0.2)
	plot!(xchi, ychi, arrow=true, c=:cyan, lab=L"\chi",lw=1,l=:dot)

	
end

# ╔═╡ 869263e2-05a8-46e2-9617-23d3d3503775
let
	theta = -deg2rad(theta1)
	# back view
	plot(
		aspect_ratio=:equal,
		xlims=(-1,1),
		ylims=(-1,1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft,
		title=L"angolo \ di \ beccheggio \ \theta \ (vista \ destra)"
	)
	airplane = transform_all(airplane_shape_side(),[0,0],[4,4],-theta)
	
	plot!(airplane,c=:black,label="")

	# xB
	plot!([0, cos(theta)], [0, -sin(theta)], arrow=true, c=:red, lab=L"\hat x_B",lw=2)
	# yB
	scatter!([0,0],[0,0], c=:green,label=L"\hat y_B",markersize=10)
	# zB
	plot!([0, -sin(theta)], [0, -cos(theta)], arrow=true, c=:blue, lab=L"\hat z_B",lw=2)

	# N
	plot!([0, 1], [0, 0], arrow=true, c=:red, lab=L"\hat x_H",lw=1,l=:dot)
	# E
	
	# D
	plot!([0, 0], [0, -1], arrow=true, c=:blue, lab=L"\hat z_H",lw=1,l=:dot)
	
	
	# theta
	xtheta,ytheta=par2dcircle(1,40,pi/2,pi/2+theta)
	plot!(xtheta,ytheta, arrow=true,label=L"\theta",lw=3, c=:coral3)
end




# ╔═╡ f5391f45-0e3c-421d-90b1-071510c1628c
let
	phi = deg2rad(phi1)
	# back view
	plot(
		aspect_ratio=:equal,
		xlims=(-1,1),
		ylims=(-1,1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft,
		title=L"angolo \ di \ rollio \ \phi \ (vista \ posteriore)"
	)
	airplane = transform_all(airplane_shape_back(),[0,0],[0.1,0.1],-phi)
	
	plot!(airplane,c=:black,label="")

	# xB
	plot!([-0.05,0.05],[-0.05,0.05], c=:red,lab=L"\hat x_B",lw=3)
	plot!([0.05,-0.05],[-0.05,0.05], c=:red,lab="",lw=3)
	# yB
	plot!([0, cos(phi)], [0, -sin(phi)], arrow=true, c=:green, lab=L"\hat y_B",lw=2)
	# zB
	plot!([0, -sin(phi)], [0, -cos(phi)], arrow=true, c=:blue, lab=L"\hat z_B",lw=2)

	# N
	plot!([-0.05,0.05],[-0.05,0.05], c=:red,lab=L"\hat x_H",lw=1,l=:dot)
	plot!([0.05,-0.05],[-0.05,0.05], c=:red,lab="",lw=1,l=:dot)
	# E
	plot!([0, 1], [0, 0], arrow=true, c=:green, lab=L"\hat y_H",lw=1,l=:dot)
	# D
	plot!([0, 0], [0, -1], arrow=true, c=:blue, lab=L"\hat z_H",lw=1,l=:dot)
	
	
	# phi
	xphi,yphi=par2dcircle(1,40,pi/2,pi/2+phi)
	plot!(xphi,yphi,arrow=true,label=L"\phi",lw=3, c=:darkblue)
end

# ╔═╡ ac80306d-2c1f-4b61-a0ad-dd97f66f4a7c
let
	psi = deg2rad(15)
	beta = deg2rad(beta1)
	# Top view
	plot(aspect_ratio=:equal,
		xlims=(-1,1),
		ylims=(-1,1),
		showaxis=false,
		legendfont=font(12),
		legend=:topleft,
		title=L"Angolo \ di \ deriva \ \beta"
	)
	airplane = transform_all(airplane_shape(),[0,0],[4,4],-psi+pi/2)
	plot!(airplane,c=:black,label="")

	# N
	plot!([0, 0], [0, 1], arrow=true, c=:red, lab=L"\hat x_H",lw=1,l=:dot)
	# E
	plot!([0, 1], [0, 0], arrow=true, c=:green, lab=L"\hat y_H",lw=1,l=:dot)
	# D
	plot!([-0.05,0.05],[-0.05,0.05], c=:blue,lab=L"\hat z_H",lw=2,l=:dot)
	plot!([0.05,-0.05],[-0.05,0.05], c=:blue,lab="",lw=2, l =:dot)
	
	# xB
	plot!([0, sin(psi)], [0, cos(psi)], arrow=true, c=:red, lab=L"\hat x_B",lw=2)
	# yB
	plot!([0, cos(psi)], [0, -sin(psi)], arrow=true, c=:green, lab=L"\hat y_B",lw=2)
	# zB
	plot!([-0.05,0.05],[-0.05,0.05], c=:blue,lab=L"\hat z_B",lw=3)
	plot!([0.05,-0.05],[-0.05,0.05], c=:blue,lab="",lw=3)

	# psi
	xpsi,ypsi=par2dcircle(1,40,0,psi)
	plot!(xpsi,ypsi,arrow=true,label=L"\psi",lw=1, c=:fuchsia,l=:dot)
	
	# v
	plot!([0, sin(beta+psi)], [0, cos(beta+psi)], arrow=true, c=:brown, lab=L"\bar v_H",lw=1,l=:dot)

	# chi
	xchi,ychi=par2dcircle(0.8,40,0,beta+psi)
	plot!(xchi, ychi, arrow=true, c=:cyan, lab=L"\chi",lw=1,l=:dot)

	# beta
	xpsi,ypsi=par2dcircle(0.6,40,psi,beta+psi)
	plot!(xpsi,ypsi,arrow=true,label=L"\beta",lw=3, c=:purple2)
	
end

# ╔═╡ 947359ba-02f8-4f1b-899a-37e47cb6132b
let
	plot(aspect_ratio=:equal,
		xlims=(-1.1, 1.1),
		ylims=(-1.1, 1.1),
		showaxis=false,
		legendfont=font(12),
		legend=:topright
	)	
	alpha = deg2rad(alpha3)
	
	# xB
	plot!([0, -1.1*cos(alpha)], [0, 1.1*sin(alpha)], arrow=true, c=:red, lab=L"\hat x_B",lw=1,l=:dot)
	# zB
	plot!([0, -sin(alpha)], [0, -cos(alpha)], arrow=true, c=:blue, label=L"\hat z_B",lw=1, l=:dot)
	# yB
	plot!([-0.05,0.05],[-0.05,0.05], c=:green,lab=L"\hat y_B = \hat y_A",lw=3)
	plot!([0.05,-0.05],[-0.05,0.05], c=:green,lab="",lw=3)

	# xA
	plot!([0, -1], [0, 0], arrow=true, c=:red, lab=L"\hat x_A",lw=2)
	# zA
	plot!([0, 0], [0, -1], arrow=true, c=:blue, lab=L"\hat z_A",lw=2)
	
	# D
	plot!([0, 1], [0, 0], arrow=true, c=:purple, lab=L"\bar D",lw=2)
	# L
	plot!([0, 0], [0, 1], arrow=true, c=:cyan, lab=L"\bar L",lw=2)

	

	naca="2412"
	foil=NACA_shape(naca)
	foil=transform_all(foil,[-1,0],[1,1],0)
	foil=transform_all(foil,[0,0],[1,1],-alpha)
	
	plot!(foil, c=:white, label = false)

	scatter!()

	# alpha
	xa,ya=par2dcircle(0.8,40,-pi/2,alpha-pi/2)
	plot!(xa, ya, arrow=true, c=:orange3, lab=L"\alpha",lw=1,l=:dot)
end

# ╔═╡ 4ece9d86-9a85-4e64-8654-3cd4c5f724d8
let
	# Dati
	
	# legame costitutivo
	CL(a,d) = CL_a .* a + CL_d .* d + CL0
	CM(a,d) = CM_a .* a + CM_d .* d + CM0
	
	# Coefficienti Portanza
	CL_a = 4.5
	CL_d = 0.2
	CL0 = 0.1
	
	# Coefficienti Momento
	CM_a = 0.5
	CM_d = 1.4
	CM0 = -0.03

	# Posizioni
	CMAC = 3
	XACw = -0.69
	XCG = -0.1

	# Adimensionalizzazioni
	ACw = XACw/CMAC
	CG = XCG/CMAC

	# Calcoli
	N = CM_a/CL_a + ACw
	XN = N * CMAC
	
	ms = CG - N
	e = ms
	
	C = CM_d/CL_d + ACw
	XC = C * CMAC
	
	d = N-C
	borri = e/d

	CL_as = CL_a*(1/(1+borri))

	# Risultati
	ES1 = [XACw,XCG,XN,XC,ms,d,borri,CL_as,sign(XC)]

	# Output
	begin
		print("X_AC = $(ES1[1]) \n")
		print("X_CG = $(ES1[2]) \n")
		print("X_N = $(ES1[3]) \n")
		print("X_C = $(ES1[4]) \n")
		print("ms = $(ES1[5]) \n")
		print("d = $(ES1[6]) \n")
		print("borri = $(ES1[7]) \n")
		print("CL_as = $(ES1[8]) \n")
		if ES1[9]<0
			print("Configurazione = standard")
		else
			print("Configurazione = canard")
		end
	end
	
	# Grafico
	pf = plot(
			aspect_ratio=:equal,
			#xlims=(-C, N),
			#ylims=(-1.1, 1.1),
			showaxis=false,
			legendfont=font(8),
			legend=false
		)

	# Profilo
	naca="2412"
	w=NACA_shape(naca)
	w=transform_all(w,[0,0],[1,1],0)
	w=transform_all(w,[0,0],[1,1],0)
	pf = plot!(w, c=:black, label = "")

	t=NACA_shape(naca)
	t=transform_all(t,[-C,0],[1,1],0)
	t=transform_all(t,[-1/4,0],[1,1],0)
	pf = plot!(t, c=:black, label = "")
	
	

	# asse x
	pf = plot!([0, -0.4], [0, 0], arrow=true, c=:red, lab=L"\hat x",lw=2)

	# M+
	xa,ya=par2dcircle(0.2,40,-pi/2,0)
	pf = plot!(xa, ya, arrow=true, c=:green, lab=L"M+",lw=2)

	# Punti
	# AC
	pf = scatter!([-ACw],[0],lab=L"X_{ACw} = %$(round(XACw,digits=3))")
	# CG
	pf = scatter!([-CG],[0],lab=L"X_{CG} = %$(round(XCG,digits=3))")
	# N
	pf = scatter!([-N],[0],lab=L"X_{N} = %$(round(N*CMAC,digits=3))")
	# C
	pf = scatter!([-C],[0],lab=L"X_{C} = %$(round(C*CMAC,digits=3))")
	# e
	pf = plot!([-CG,-N],[-0.2,-0.2],lab=L"ms = %$(round(ms,digits=3))",lw=3)
	# d
	pf = plot!([-N,-C],[-0.4,-0.4],lab=L"d = %$(round(d*CMAC,digits=3))",lw=3)
	# borri
	#pf = scatter!([100],[100],lab=L"\epsilon = %$(round(borri,digits=3))")

	

end

# ╔═╡ ebe6d9e9-3736-46b5-8864-ced2fe754cb5
let
	
	# Dati
	Sw = 98
	St = 16.7
	ms = 0.12
	
	# CL^w/alpha (ala) e CL^t/alpha (coda)
	aw = 4.85
	at = 4.11
	
	# Posizioni adimensionalizzate
	ACw = -0.041
	CG = -0.281
	
	# Coefficienti ala -> coda 
	epsilon_alpha = 0.33
	eta = 0.98
	sigma = St/Sw
	
	# Calcoli
	N = CG - ms
	ACt = N-((ACw - N) * aw)/(eta * sigma*(1-epsilon_alpha)*at)

	borri = (CG-N)/(N-ACt)
	
	C = ACt

	d = (N-C)

	CL_a = aw + eta * sigma * (1-epsilon_alpha)*at

	CL_as = 1/(1+borri)*CL_a

	ms2 = (CL_a/(CL_as * 1.04)-1)*d

	CG2 = ms2 + N

	borrit = (CG2-N)/(N-ACt)

	CL_ast = 1/(1+borrit)*CL_a
	test = round(CL_as*1.04-CL_ast)
	
	# Risultati
	ES1_2 = [N,ACt,borri,CL_as,ms2,CG2]

	begin
		print("xi N = $(ES1_2[1]) \n")
		print("xi ACt = $(ES1_2[2]) \n")
		print("borri = $(ES1_2[3]) \n")
		print("CL_a trimm = $(ES1_2[4]) \n")
		print("ms2 = $(ES1_2[5]) \n")
		print("CG2 = $(ES1_2[6]) \n")
	end

	# Grafico
	pf = plot(
			aspect_ratio=:equal,
			#xlims=(-C, N),
			#ylims=(-1.1, 1.1),
			showaxis=false,
			legendfont=font(8),
			legend=true
		)

	# Profilo
	naca="2412"
	w=NACA_shape(naca)
	w=transform_all(w,[0,0],[1,1],0)
	w=transform_all(w,[0,0],[1,1],0)
	pf = plot!(w, c=:black, label = "")

	t=NACA_shape(naca)
	t=transform_all(t,[-C,0],[1,1],0)
	t=transform_all(t,[-1/4,0],[1,1],0)
	pf = plot!(t, c=:black, label = "")
	
	# asse x
	pf = plot!([0, -0.4], [0, 0], arrow=true, c=:red, lab=L"\hat x",lw=2)

	# M+
	xa,ya=par2dcircle(0.2,40,-pi/2,0)
	pf = plot!(xa, ya, arrow=true, c=:green, lab=L"M+",lw=2)

	# Punti
	# N
	pf = scatter!([-N],[0],lab=L"N = %$(round(N,digits=3))")
	# C
	#pf = scatter!([-C],[0],lab=L"C = %$(round(C,digits=3))")
	# CG
	pf = scatter!([-CG],[0],lab=L"CG = %$(round(CG,digits=3))")
	# CG2
	pf = scatter!([-CG2],[0],lab=L"CG2 = %$(round(CG2,digits=3))")
	# e
	pf = plot!([-CG,-N],[-0.2,-0.2],lab=L"ms = %$(round(ms,digits=3))",lw=3)
	# e2
	pf = plot!([-CG2,-N],[-0.4,-0.4],lab=L"ms = %$(round(ms2,digits=3))",lw=3)
	# d
	#pf = plot!([-N,-C],[-0.4,-0.4],lab=L"d = %$(round(d,digits=3))",lw=3)
	
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Rotations = "6038ab10-8711-5258-84ad-4b1120ba62dc"

[compat]
LaTeXStrings = "~1.3.1"
Plots = "~1.40.0"
PlutoUI = "~0.7.55"
Rotations = "~1.6.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "a6ba16b49b6b523ad4098639ba459cacb4006623"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "75bd5b6fc5089df449b5d35fa501c846c9b6549b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.12.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "ac67408d9ddf207de5cfa9a97e114352430f01ed"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.16"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "3458564589be207fa6a77dbbf8b97674c9836aab"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "77f81da2964cc9fa7c0127f941e8bce37f7f1d70"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.2+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60b1194df0a3298f460063de985eae7b01bc011a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.1+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "862942baf5663da528f66d24996eb6da85218e76"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "38a748946dca52a622e79eea6ed35c6737499109"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "9a46862d248ea548e340e30e2894118749dc7f51"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.5"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "792d8fd4ad770b6d517a13ebb8dadfcac79405b8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.6.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "7b0e9c14c624e435076d19aea1e5cbdec2b9ca37"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.2"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─38b8bf30-b673-11ee-0868-8df22983dbe9
# ╟─51934362-4b1f-4aea-bcf3-a3a892de83a1
# ╠═258dcb67-de1f-48b6-978f-86ba4603b244
# ╟─3ea80b56-a7c7-4dd1-aae3-e240e0042145
# ╟─8e429280-d45f-4aaa-8db6-bb865822def4
# ╟─ce9842db-1d24-43dc-8d23-6964719c80a2
# ╠═e4f7b60f-7c55-462c-9ced-da14638b66ae
# ╠═f66827da-440b-4b91-a085-063a9bcfad57
# ╟─c1e6d919-f3c6-4ae0-ad6c-eb6e22b82d3d
# ╟─659b9467-0144-4aa5-ba2e-ff76182ee87b
# ╠═c1fc80bc-c3aa-4f2e-bc53-6cb770964a87
# ╠═b79ae4e0-96fb-478e-8fc8-3316c6e394ce
# ╟─c339e1dd-5889-46c7-874b-e6cc048a39bc
# ╟─69e84cbe-b7e4-48c5-a819-3f471f4d091c
# ╠═52942653-05c3-4eaa-bf3e-f594a089bd1c
# ╟─bc13b7b3-7fc4-4007-9025-2597005fa63a
# ╠═5890b370-d1b9-4372-b429-e2d902a98085
# ╟─cfb0dd04-abd4-497d-8ed6-1c5e6c3a0ee4
# ╟─45661987-c61e-4864-97a6-ac0ac6010d39
# ╟─a679ab80-4fbb-4e10-845a-bb9ca338bc69
# ╟─82e5b6b0-def9-46ce-9e1e-8bf25a54b24e
# ╠═041459bb-0fad-4ed5-87f9-0c873ae7cfaa
# ╟─4c58ff04-6f48-4247-8bbb-7a9593432368
# ╟─bb575fbf-c996-4557-8b08-cc28db9c0db4
# ╟─7df38388-286b-4767-8bc6-e56cfdb1f656
# ╟─8934ba0d-dbf5-4ef7-9733-530dcd42ef05
# ╠═9ab15e4e-75d8-4fdf-ad53-8dfde7615a95
# ╟─d44fb526-84b6-4c13-aace-7ffa36a861b1
# ╟─90e78e30-90f6-48cd-b699-3493cd662713
# ╟─4ed72bd1-6fea-4a90-ae20-b23300f63085
# ╟─d3e9ee9d-fcdc-4eab-908a-19301fe18a0a
# ╟─f053e0cb-ea7d-43a7-97cf-a90d7d6fa3d4
# ╟─337267df-a02d-4163-8bac-98ddd734ea18
# ╟─ed65d686-ebaf-4cf4-a779-0283fd36583c
# ╟─d8c80578-7c6a-41f6-ab49-e33ee4fbdd9b
# ╟─9350c9d1-f4cd-4633-8513-50ac1a9311ef
# ╟─31437c3c-a21a-4301-9efd-de00c86a0e2e
# ╟─f1b15f3f-60a4-4605-953b-f4393a2de8a2
# ╟─49f7985f-e7f4-4cae-bbe3-c1821489c76c
# ╟─8c312483-ec4d-4c1d-a88a-626f7715928a
# ╟─42038324-7780-4b84-a0de-2f36cf30212b
# ╟─d6ef6fcb-ee92-4d71-a0b4-5d25befaa16f
# ╟─46d626ec-d721-468e-9129-7ae9334d7c05
# ╟─0635e8b7-1ebc-4a28-94fc-da0796146b4e
# ╟─05ec308d-c9f9-4c17-b15d-ada5d0a64b89
# ╟─1c754b21-6a19-4752-9ec4-8e4bd37b73a0
# ╟─b5fe8375-2d01-44e6-9b1d-718009dba565
# ╟─94c96468-411c-4e01-b2f1-88cff2b6169c
# ╟─e8bbcc41-02b6-43d7-b842-21ddfa92b49b
# ╟─43e6a216-fbc3-4b91-ac5e-144f60152e35
# ╟─4f1f40e4-0d53-41dd-a8bc-93c69a3e0c1b
# ╟─869263e2-05a8-46e2-9617-23d3d3503775
# ╟─140eb5fe-d3c7-4c0e-bc2d-b7e377a953d5
# ╟─f5391f45-0e3c-421d-90b1-071510c1628c
# ╟─0a9510c2-7b71-44d5-8223-9d398890a53b
# ╟─c53bc007-1f1e-41e7-a9c3-c71a0d6c63c1
# ╟─ac80306d-2c1f-4b61-a0ad-dd97f66f4a7c
# ╟─afe62312-eff7-4c8d-8f9b-03b4a94eac40
# ╟─69424d76-9aa9-4be2-8e90-514824645980
# ╟─c55079d2-0bf7-4094-bcf8-8de86d0d001a
# ╟─93b9b3a4-9493-4085-a73e-9b8c4be45b96
# ╟─65b12662-2f8f-4bea-aadf-d7791eb24ecd
# ╟─86118dd3-99f7-4470-b9c1-ab5c8be001c3
# ╟─8c7a0753-17f0-41e8-8349-28c2d309cade
# ╟─454992df-7cf2-439f-97a3-f47df6d4ce14
# ╟─47e28d45-2a52-4a78-9970-efd6436a377e
# ╟─4b0d29d1-43e3-4db7-a797-0ca2e08a51c0
# ╟─dc250eda-e9d9-437d-b549-2992973d9cf1
# ╟─5777b4ce-2eac-44ec-ab14-cf06d6577065
# ╟─ba58fd28-983b-4688-bd7c-14512fe63402
# ╟─ebcb05ec-541e-40c5-9438-e5db68747541
# ╟─a765006c-29fb-47cc-801e-d9cf62952091
# ╟─18a37d1e-2ce2-4710-b429-788c559c31c3
# ╟─229ffa9f-145b-4fe1-b063-0ffb598bb918
# ╟─6a64478c-4a13-454e-a2fc-19e289638b44
# ╟─66ce96db-5d29-4761-b069-b885f224754b
# ╟─947359ba-02f8-4f1b-899a-37e47cb6132b
# ╟─a1211f22-1f94-47fe-ae55-b5d06bb3000e
# ╟─cb81651b-b845-4352-ac5b-6de837c81daa
# ╟─b83382c0-6f94-430c-bce2-8963150dce48
# ╟─3ad6fce1-fb0e-446a-b724-81af756eecb3
# ╟─4187da49-e658-4ec6-9e6b-dbeefc086173
# ╟─b2f6bec4-449a-4299-8cda-4f7645627728
# ╟─6bb79929-043e-426c-885f-b62647bf5279
# ╟─ed1c4634-14db-457b-86b9-c1cb5829b927
# ╟─6d3df4f8-6f48-4aba-ac2f-6b4d50470522
# ╟─1aee1451-5479-4110-b181-3a5ec856841f
# ╟─9d7935b8-c73b-474d-af5a-891266ead65c
# ╟─922102af-abb4-4905-91ef-e4a16c2ea6f7
# ╟─2465f157-287f-4d24-84ad-bfc48b6e814f
# ╟─af97f9d3-b2d3-4576-8729-6d72a6a5db1f
# ╟─4ece9d86-9a85-4e64-8654-3cd4c5f724d8
# ╟─73f59f92-f3d7-4372-a863-33978479a984
# ╟─b05df4d0-dbdd-4f65-90d3-c8fae9430900
# ╟─10783065-3c6e-47a1-bccb-5675b3573563
# ╟─b525969a-c0c5-4471-b0e7-9d3f3b829819
# ╟─7c8954f2-fa31-4d1a-90ca-575dccf2db07
# ╟─ebe6d9e9-3736-46b5-8864-ced2fe754cb5
# ╟─988be133-a521-4afc-9919-ab65fef8e512
# ╠═f6717f17-30c4-49bd-abf2-623dd7f78d9d
# ╟─43b35f35-5d9c-4fc2-b778-e356cad72978
# ╟─a9935d19-6ab2-4044-bc3e-07089e8801d5
# ╟─68b98a8b-da00-4678-9de2-26f329e7226a
# ╟─a47a670f-db88-477c-8eb1-561e5b3fdf27
# ╟─14c78908-06ae-4636-a7eb-ac387c759e8a
# ╟─14e7a4a4-b209-401c-845a-bc199851195a
# ╟─f00df351-e2da-4886-947c-95a0f684c13e
# ╟─6123f526-a9f1-41d7-8499-09e56465f9e0
# ╟─6b07a0d6-5c00-49f4-9d0c-ad2f9bb5e3ac
# ╟─5aeef1e9-f16b-43f3-b7be-d083e15c70c7
# ╟─36737977-5a27-45f3-a0ce-84c1badd4dce
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
