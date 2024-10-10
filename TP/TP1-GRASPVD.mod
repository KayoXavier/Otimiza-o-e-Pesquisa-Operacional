//TP Final - Cainã Penna Mendes, Kayo Xavier Nascimento Cavalacante Leite e Rafael Xavier Ribeiro

//"Uma heurística baseada em GRASP-VND para o Problema de Roteamento de Mula de Dados em Redes Mistas"

// Conjuntos
int n = ...; // número de sensores

range Sensores= 1..n; // conjunto de sensores

int b = ...; // nó base

// Parâmetros

float distancia[Sensores][Sensores] = ...; // distâncias entre os sensores

float raio[Sensores]= ...; // raio de comunicação de cada sensor

setof(int) C[i in Sensores] = {j | j in Sensores: (distancia[i][j] <= raio[i])}; // C define se o nó j está dentro do raio de comunicação de i 

// Variaveis de Decisão

dvar boolean x[Sensores][Sensores]; // True se a aresta [i][j] faz parte da solução, false caso contrario

dvar boolean y[Sensores]; // Variavel que indica se sensor foi visitado

dvar int+ z[Sensores][Sensores]; // Variavel para eliminação de subciclos

// Função Objetivo 

minimize sum(i in Sensores, j in Sensores: i != j) distancia[i][j] * x[i][j]; //minimiza a distancia percorrida pela mula para visitar(ou receber dados) de todos os sensores

// Restrições

subject to {
    // Restrições para garantir que cada sensor é coberto
    forall(i in Sensores) //Restrição 3
        sum(j in C[i]) y[j] >= 1; // garante que se o sensor estiver dentro do raio r de outro ja visitado, não necessariamente há necessidade de visita-lo

    // Restrições de fluxo para garantir a formação de um ciclo
    
    forall(i in Sensores)//restrição 4
        sum(j in Sensores: i != j) x[i][j] == y[i];

    forall(i in Sensores)//restrição 5
        sum(j in Sensores: i != j) x[j][i] == y[i];
	
	// Restrição para garantir que a base seja visitada
	y[b] == 1;// restrição 6


	// Para cada nó exceto a base (0), o fluxo de entrada e saída deve ser balanceado (deve-se entrar e sair do nó)
  	forall(i in Sensores: i != b) //restricao 7
    	sum(j in Sensores: (i != j)) z[i][j] == sum(j in Sensores: (i != j)) z[j][i] + y[i];
    	
   // O fluxo entre dois nós só é permitido se houver cobertura,ou seja, só permite fluxo entre nós que estão efetivamente sendo cobertos na solução.
    forall(i in Sensores, j in Sensores: i != j)//restricao 8
    	z[i][j] <= sum(k in Sensores) y[k];

    //Limitação do numero de nos visitados seja menor que n
    forall(i in Sensores, j in Sensores: i != j)// restricao 9
        z[i][j] <= n * x[i][j];
        
	// O fluxo de saída da base deve ser igual ao número de nós visitados, garante que o ciclo retorne a base	
    sum(j in Sensores: j != b) z[b][j] == y[b];
    
}
