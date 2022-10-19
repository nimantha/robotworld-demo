<script>
    import { selectedAccount, Web3 } from "svelte-web3";
    import ReobotsFactoryContract from "./contracts/RobotFactory.json";
    import { onMount } from "svelte";
    import Icon from "@iconify/svelte";

    $: promise = getAllRobots();
    const web3 = new Web3(window.ethereum);

    let name = "";
    let master = "default_boss";
    let counter = 0;
    let robots = [];
    let selectedRobotAddress = "";
    let selectedRobotMaster = "";
    let selectedId = -1;
    let implAddress = "";

    onMount(async () => {
        getImpl();
    });

    async function getRobotMaster(idx, addr) {
        const contract = await getRobotFactoryContract();
        const response = await contract.methods.getRobotMaster(idx).call();
        selectedRobotMaster = response;
        selectedRobotAddress = addr;
        selectedId = idx;
        return response;
    }

    async function setRobotMaster(idx, master) {
        const accounts = await web3.eth.getAccounts();
        const contract = await getRobotFactoryContract();
        await contract.methods
            .setRobotMaster(idx, master)
            .send({ from: accounts[0] });
        promise = getAllRobots();
    }

    async function getAllRobots() {
        const contract = await getRobotFactoryContract();
        const response = await contract.methods.getAllRobots().call();
        robots = response;

        console.log(response);
        return response;
    }

    async function useBrain(idx) {
        const contract = await getRobotFactoryContract();
        const response = await contract.methods.useRobotBrain(idx).call();
        alert(response);
    }

    async function updateImpl(address) {
        const accounts = await web3.eth.getAccounts();
        const contract = await getRobotFactoryContract();
        const response = await contract.methods
            .setImplementation(address)
            .send({ from: accounts[0] });
        getImpl();
    }

    async function getImpl() {
        const contract = await getRobotFactoryContract();
        implAddress = await contract.methods.getImplementation().call();
        console.log("Impl address: ", implAddress);
    }

    async function createRobot(name, master) {
        const accounts = await web3.eth.getAccounts();
        const contract = await getRobotFactoryContract();
        await contract.methods
            .createRobot(name, master)
            .send({ from: accounts[0] });
        // robots.push({ name: name, master: master });

        promise = getAllRobots();
    }

    async function getRobotFactoryContract() {
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        return new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
    }
</script>

{#await promise}
    <h1>Loading ...</h1>
{:then count}
    <h1>Welcome to the Robot World</h1>
    <h4>Current robot population is {robots.length}</h4>
    <fieldset class="robot-box">
        <legend>Robot Management</legend>
        <div class="sub-box">
            <h2>Create new robot</h2>
            <label for="name">Name:</label>
            <input
                name="name"
                placeholder="Please enter any name"
                bind:value={name}
            />
            <label for="master">Master:</label>
            <input name="master" bind:value={master} />
            <button on:click={createRobot(name, master)}>Build Robot!</button>
        </div>
        <div class="sub-box">
            <label for="master">Robot Implementation:</label>
            <input name="master" bind:value={implAddress} />
            <button on:click={updateImpl(implAddress)}
                >Update Implementation Address</button
            >
        </div>
    </fieldset>
    <fieldset class="robot-box">
        <legend>Robot Registry</legend>
        {#each robots as robo, index}
            <ul>
                <li
                    class="robot_item"
                    on:mousedown={(e) => getRobotMaster(index, robo)}
                >
                    <Icon icon="mdi:robot" />
                    {robo}
                </li>
            </ul>
        {:else}
            No robots yet
        {/each}
    </fieldset>
    <fieldset class="robot-details robot-box">
        <legend>Robot Details</legend>
        {#if selectedRobotMaster}
            <h2>Robot details</h2>
            <label for="address">Address:</label>
            <input name="name" disabled bind:value={selectedRobotAddress} />
            <label for="master">Master:</label>
            <input name="master" bind:value={selectedRobotMaster} />
            <button on:click={setRobotMaster(selectedId, selectedRobotMaster)}
                >Update master</button
            >
            <button on:click={useBrain(selectedId)}>Use Brain</button>
        {:else}
            <p>Please select a Robot!</p>
        {/if}
    </fieldset>
{/await}
