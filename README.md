# 📚 Simple DEX Solidity Final Project

Este repositorio contiene el trabajo final para la clase de Solidity:
**Creación de un Exchange Descentralizado Simple con Pools de Liquidez**  
Desplegado en la red **Scroll Sepolia**.

---

## 📂 Estructura del repositorio

Decentralized-Exchange/
│
├── contracts/
│ ├── TokenA.sol
│ ├── TokenB.sol
│ ├── SimpleDEX.sol
│
├── README.md

---

## ✅ Contratos incluidos

### 1️⃣ **TokenA.sol**

- Implementa un token ERC-20 fungible llamado `TokenA` (`STA`).
- Suministro inicial configurable en el constructor.
- Incluye funciones estándar:
  - `transfer`
  - `approve`
  - `transferFrom`
  - `allowance`
  - `balanceOf`

### 2️⃣ **TokenB.sol**

- Implementa otro token ERC-20 fungible llamado `TokenB` (`STB`).
- Igual que `TokenA`, pero representa el segundo activo para el pool.
- Mismo flujo de creación, transferencia y aprobaciones.

### 3️⃣ **SimpleDEX.sol**

- Contrato principal del **exchange descentralizado simple**.
- Permite:
  - **Añadir liquidez:** `addLiquidity(uint amountA, uint amountB)`  
  - **Intercambiar tokens:** `swapAforB` y `swapBforA` usando fórmula AMM (producto constante).
  - **Retirar liquidez:** `removeLiquidity(uint amountA, uint amountB)`
  - **Consultar precio:** `getPrice(address _token)`
- Administra los saldos de TokenA y TokenB en el pool.
- Requiere `approve` previo en cada token para permitir `transferFrom`.

---

## 🚀 Despliegue y pruebas

1. Desplegar `TokenA` y `TokenB` en **Scroll Sepolia** usando Remix.
2. Desplegar `SimpleDEXTest` pasando las direcciones de TokenA y TokenB.
3. Asegurar que el `owner()` sea tu wallet.
4. Usar `approve` en ambos tokens para permitir que el DEX mueva tokens.
5. Ejecutar `addLiquidity`, `swapAforB`, `swapBforA` y `removeLiquidity` para interactuar con el pool.

---

## 📝 Autor

Jean Pool Cruz  
Clase de Solidity – ETH Kipu  
2025