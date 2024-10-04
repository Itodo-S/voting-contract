import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const VotingModule = buildModule("VotingModule", (m) => {
  const vote = m.contract("Voting", []);
  return { vote };
});

export default VotingModule;