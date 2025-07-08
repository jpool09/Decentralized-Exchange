// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TokenA
 * @dev Implementación básica del estándar ERC-20 para fines educativos
 * @notice Este contrato implementa un token fungible siguiendo el estándar ERC-20
 * @author EDP-ETH Kipu
 * 
 */
contract TokenA {
    
    // ============================
    // METADATOS DEL TOKEN
    
    //Constante que define el nombre legible del token
    string public constant name = "TokenA";
    
    //@notice Constante que define el símbolo corto del token (como BTC, ETH)
    string public constant symbol = "STA";
    
    //@notice Define la divisibilidad del token. 18 decimales = Wei compatibility
    uint8 public constant decimals = 18;
    
    // ============================
    // EVENTOS (LOGS)
    
    //Evento emitido cuando tokens son transferidos
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /**
     * @dev Evento emitido cuando se aprueba un gasto delegado
     * @param owner Dirección del propietario de los tokens
     * @param spender Dirección autorizada para gastar los tokens
     * @param value Cantidad de tokens aprobados para gastar
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    // ============================
    // VARIABLES DE ESTADO
    
    //@dev Mapping que almacena el balance de cada dirección
    mapping(address => uint256) balances;
    
    /**
     * @dev Mapping anidado para aprobaciones de gasto
     * @notice allowed[owner][spender] = cantidad que spender puede gastar de owner
     * @dev Permite transferencias delegadas (transferFrom)
     * @dev Estructura: propietario => gastador => cantidad_aprobada
     */
    mapping(address => mapping(address => uint256)) allowed;
    
    //@notice Cantidad total de tokens que existen en el contrato
    uint256 totalSupply_;
    
    // ============================
    // CONSTRUCTOR
    
    /**
     * @dev Constructor que inicializa el contrato
     * @param total Suministro inicial de tokens (en unidades mínimas)
     * @notice Asigna todos los tokens al deployer del contrato
     * 
     * EJEMPLO DE USO:
     * - Para 1,000,000 tokens: pasar 1000000000000000000000000
     * - Cálculo: 1,000,000 * 10^18 = 1,000,000 tokens con 18 decimales
     * 
     * COMPORTAMIENTO:
     * 1. Establece el suministro total
     * 2. Asigna todos los tokens al msg.sender (deployer)
     * 3. msg.sender se convierte en el propietario inicial de todos los tokens
     */
    constructor(uint256 total) {
        totalSupply_ = total;                    // Establece suministro total
        balances[msg.sender] = totalSupply_;     // Asigna todos al deployer
    }
    
    // ============================
    // FUNCIONES PÚBLICAS DE CONSULTA (VIEW)
    
    //@dev Retorna el suministro total de tokens
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    
    //retorna el balance de tokens de una dirección específica
    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }
    
    /**
     * @dev Consulta la cantidad aprobada que un gastador puede usar
     * @param owner Dirección del propietario de los tokens
     * @param delegate Dirección del gastador autorizado
     * @return uint Cantidad de tokens que delegate puede gastar de owner
     */
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }
    
    // ============================
    // FUNCIONES PÚBLICAS DE MODIFICACIÓN
    
    /**
     * @dev Transfiere tokens del caller a otra dirección
     * @param receiver Dirección que recibirá los tokens
     * @param numTokens Cantidad de tokens a transferir
     * @return bool Siempre retorna true si la transacción no falla
     */
    function transfer(address receiver, uint256 numTokens) public returns (bool) {
        // VALIDACIÓN: El sender debe tener suficientes tokens
        require(numTokens <= balances[msg.sender]);
        
        // ACTUALIZACIÓN DE BALANCES
        balances[msg.sender] = balances[msg.sender] - numTokens;  // Reduce sender
        balances[receiver] = balances[receiver] + numTokens;      // Aumenta receiver
        
        // EMISIÓN DE EVENTO
        emit Transfer(msg.sender, receiver, numTokens);
        
        return true; 
    }
    
    /**
     * @dev Aprueba a otra dirección para gastar tokens en tu nombre
     * @param delegate Dirección que será autorizada para gastar
     * @param numTokens Cantidad de tokens que puede gastar
     * @return bool Siempre retorna true si la transacción no falla
     */
    function approve(address delegate, uint256 numTokens) public returns (bool) {
        // ESTABLECER APROBACIÓN
        allowed[msg.sender][delegate] = numTokens;
        
        // EMISIÓN DE EVENTO 
        emit Approval(msg.sender, delegate, numTokens);
        
        return true;
    }
    
    /**
     * @dev Transfiere tokens de una dirección a otra usando aprobación previa
     * @param owner Dirección desde la cual transferir tokens
     * @param buyer Dirección que recibirá los tokens
     * @param numTokens Cantidad de tokens a transferir
     * @return bool Siempre retorna true si la transacción no falla
     * 
     * PRERREQUISITOS:
     * - owner debe haber aprobado al msg.sender para gastar numTokens
     * - owner debe tener suficiente balance
     * 
     * VALIDACIONES:
     * 1. owner tiene suficientes tokens
     * 2. msg.sender tiene suficiente aprobación de owner
     * 
     * 
     * EJEMPLO DE FLUJO:
     * 1. Alice aprueba a Bob: approve(bob, 1000)
     * 2. Bob transfiere: transferFrom(alice, charlie, 500)
     * 3. Resultado: Alice -500, Charlie +500, aprobación Bob: 500
     */
    function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        // VALIDACIÓN 1: El owner debe tener suficientes tokens
        require(numTokens <= balances[owner]);
        
        // VALIDACIÓN 2: El msg.sender debe tener suficiente aprobación
        require(numTokens <= allowed[owner][msg.sender]);
        
        // ACTUALIZACIÓN DE BALANCES
        balances[owner] = balances[owner] - numTokens;           
        balances[buyer] = balances[buyer] + numTokens;           
        
        // ACTUALIZACIÓN DE APROBACIÓN
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        
        // EMISIÓN DE EVENTO 
        emit Transfer(owner, buyer, numTokens);
        
        return true;  
    }
}