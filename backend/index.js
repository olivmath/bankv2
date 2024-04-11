const Web3 = require("web3");

// Endereço do seu smart contract
const ANVIL_URL = "http://127.0.0.1:8545";
const PRIVATE_KEY =
  "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const CONTRACT_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const CONTRACT_ABI = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "EmployeeAlreadyAdd",
    type: "error",
  },
  {
    inputs: [],
    name: "EmployeeNotFound",
    type: "error",
  },
  {
    inputs: [],
    name: "LocktimeTooLow",
    type: "error",
  },
  {
    inputs: [],
    name: "SalaryTooLow",
    type: "error",
  },
  {
    inputs: [],
    name: "Unauthorized",
    type: "error",
  },
  {
    inputs: [],
    name: "ZeroAddress",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "employee",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "bonus",
        type: "uint256",
      },
    ],
    name: "Bonus",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "employee",
        type: "address",
      },
    ],
    name: "DeleteEmployee",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "NewDeposit",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "employee",
        type: "address",
      },
    ],
    name: "NewEmployee",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "token",
        type: "address",
      },
    ],
    name: "NewToken",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "employee",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "salary",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "nextPayment",
        type: "uint256",
      },
    ],
    name: "Paid",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "employee",
        type: "address",
      },
    ],
    name: "UpdateEmployee",
    type: "event",
  },
  {
    inputs: [],
    name: "controller",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_employee",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_salary",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_locktime",
        type: "uint256",
      },
    ],
    name: "createEmployee",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_employee",
        type: "address",
      },
    ],
    name: "deleteEmployee",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getAllEmployees",
    outputs: [
      {
        internalType: "address[]",
        name: "",
        type: "address[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getBalance",
    outputs: [
      {
        internalType: "uint256",
        name: "balance",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_employee",
        type: "address",
      },
    ],
    name: "getEmployee",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "employee",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "salary",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "locktime",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "nextPayment",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "bonus",
            type: "uint256",
          },
        ],
        internalType: "struct Employee",
        name: "emp",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getToken",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getTotalEmployeeCost",
    outputs: [
      {
        internalType: "uint256",
        name: "totalCost",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "payAllEmployees",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
    ],
    name: "setToken",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "token",
    outputs: [
      {
        internalType: "contract ERC20",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_employee",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_salary",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_locktime",
        type: "uint256",
      },
    ],
    name: "updateEmployee",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

// Iniciar conexão com a blockchain
const web3 = new Web3(ANVIL_URL);

// Criar instância do contrato
const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS);

// Ouvir novos blocos
web3.eth.subscribe("newBlockHeaders", async (error, result) => {
  if (!error) {
    await payEmployees();
  } else {
    console.error(error);
  }
});

// Ouvir eventos do tipo Bonus
contract.events
  .Bonus()
  .on("data", async (event) => {
    try {
      // Chamar as funções getTotalEmployeeCost e getBalance
      const totalCost = await contract.methods.getTotalEmployeeCost().call();
      const balance = await contract.methods.getBalance().call();

      // Logar um alerta se necessário
      console.log("🚨 ATENÇÃO: o contrato precisa de financiamento");
      console.table({ totalCost, balance });
    } catch (e) {
      console.error("Erro ao processar evento Bonus:", e);
    }
  })
  .on("error", console.error);

async function payEmployees() {
  const data = contract.methods.payEmployees().encodeABI();

  let nonce;
  let gasPrice;
  let signedTx;

  try {
    nonce = await web3.eth.getTransactionCount(fromAddress);
    console.log("✅ Get nonce sucessful: ", nonce);
  } catch (error) {
    console.error("Erro ao pegar o nonce: ", error.message);
  }
  try {
    gasPrice = await web3.eth.getGasPrice();
    console.log("✅ Get gasPrice successful: ", gasPrice);
  } catch (error) {
    console.error("Erro ao pegar o gasPrice: ", error.message);
  }

  const tx = {
    from: fromAddress,
    to: CONTRACT_ADDRESS,
    gasPrice: gasPrice,
    data: data,
    nonce: nonce,
    chainId: 31337,
    value: web3.utils.toHex(0),
    gas: web3.utils.toHex(50000),
  };
  try {
    signedTx = await web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
    console.log("✅ Sign tx successful");
  } catch (error) {
    console.error("Erro ao assinar a tx: ", error.message);
  }

  try {
    const txReceipt = await web3.eth.sendSignedTransaction(
      signedTx.rawTransaction
    );
    console.log(
      "✅ Transfer successful. Transaction hash: ",
      txReceipt.transactionHash
    );
  } catch (error) {
    console.error("Error enviar a tx: ", error.message);
  }
}
