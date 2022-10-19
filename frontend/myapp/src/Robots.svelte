<script>
    import { selectedAccount, Web3 } from "svelte-web3";
    import ReobotsFactoryContract from "./contracts/RobotFactory.json";
    import { onMount } from 'svelte';

    $: promise = getAllRobots();

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

    async function setCount(count) {
        const web3 = new Web3(window.ethereum);
        const accounts = await web3.eth.getAccounts();
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        await contract.methods.setCount(counter).send({ from: accounts[0] });
        promise = getCount();
    }

    async function getCount() {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const response = await contract.methods.getRobotCount().call();
        return response;
    }

    async function getRobotMaster(idx, addr) {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const response = await contract.methods.getRobotMaster(idx).call();
        selectedRobotMaster = response;
        selectedRobotAddress = addr;
        selectedId = idx;
        return response;
    }

    async function setRobotMaster(idx, master) {
        const web3 = new Web3(window.ethereum);
        const accounts = await web3.eth.getAccounts();
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        await contract.methods.setRobotMaster(idx, master).send({ from: accounts[0] });
        promise = getAllRobots();
    }

    async function getAllRobots() {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const response = await contract.methods.getAllRobots().call();
        robots = response;

        console.log(response);
        return response;
    }

    async function useBrain(idx) {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const response = await contract.methods.useRobotBrain(idx).call();
        alert(response);
    }

    async function updateImpl(address) {
        const web3 = new Web3(window.ethereum);
        const accounts = await web3.eth.getAccounts();
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const response = await contract.methods.setImplementation(address).send({ from: accounts[0] });
        getImpl();
    }

    async function getImpl() {
        const web3 = new Web3(window.ethereum);
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        implAddress = await contract.methods.getImplementation().call();
        console.log("Impl address: ", implAddress);
    }


    async function createRobot(name, master) {
        const web3 = new Web3(window.ethereum);
        const accounts = await web3.eth.getAccounts();
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = ReobotsFactoryContract.networks[networkId];
        const contract = new web3.eth.Contract(
            ReobotsFactoryContract.abi,
            deployedNetwork && deployedNetwork.address
        );
        const robotAddress = await contract.methods
            .createRobot(name, master)
            .send({ from: accounts[0] });
        // robots.push({ name: name, master: master });

        promise = getAllRobots();
    }
</script>

{#await promise}
    <h1>Loading ...</h1>
{:then count}
    <h1>Current robot population is {robots.length}</h1>
    <h2>Create new robot</h2>
    <label for="name">Name:</label>
    <input name="name" bind:value={name} />
    <label for="master">Master:</label>
    <input name="master" bind:value={master} />
    <button on:click={createRobot(name, master)}>Build Robot!</button>
    <br>
    <label for="master">Robot Implementation:</label>
    <input name="master" bind:value={implAddress} />
    <button on:click={updateImpl(implAddress)}>Update Implementation Address</button>
    

    <ul>
        {#each robots as robo, index}
            <li on:mousedown={(e) => getRobotMaster(index, robo)}>{robo}</li>
        {:else}
            <li>No robots yet</li>
        {/each}
    </ul>
{/await}

{#if selectedRobotMaster}
    <h2>Robot details</h2>
    <label for="address">Address:</label>
    <input name="name" disabled bind:value={selectedRobotAddress} />
    <label for="master">Master:</label>
    <input name="master" bind:value={selectedRobotMaster} />
    <button on:click={setRobotMaster(selectedId, selectedRobotMaster)}>Update master</button>
    <button on:click={useBrain(selectedId)}>Use Brain</button>
{/if}
