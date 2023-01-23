#### No deposit:

The statement should look like

```
You have not Deposited/Withdrawn from this account yet
```

---

#### One deposit:

- Deposit 1000 on 10-01-2023

The statment should look like

```
date || credit || debit || balance
10/01/2023 || 1000.00 || || 1000.00
```

---

#### Withdrawing when no money is in the account

- Withdraw 100 on 10-01-2023

Raises error with the message `You cannot withdraw 100.00 from your account, your current balance is 0.00`

---

#### Withdrawing when not enough money is in the account

- Deposit 15 on 10-01-2023
- Withdraw 100 on 11-01-2023

---

#### Successive deposits and a valid withdrawl

- Deposit 1000 on 10-01-2023
- Deposit 2000 on 13-01-2023
- Withdraw 500 on 14-01-2023

The statement should look like

```
date || credit || debit || balance
14/01/2023 || || 500.00 || 2500.00
13/01/2023 || 2000.00 || || 3000.00
10/01/2023 || 1000.00 || || 1000.00
```

---

#### Series of valid deposits/withdrawls

- Deposit 300 on 11-01-2023
- Withdraw 150 on 11-01-2023
- Withdraw 50 on 12-01-2023
- Deposit 40 on 14-01-2023

The statement should look like

```
date || credit || debit || balance
14/01/2023 || 40.00 || || 140.00
12/01/2023 || || 50.00 || 100.00
11/01/2023 || || 150.00 || 150.00
11/01/2023 || 300.00 || || 300.00
```

---

- Deposit 1000 on 10-01-2023
- Deposit 2000 on 13-01-2023
- Withdraw 500 on 14-01-2023

Saving the account to `account_01.csv` should look like

```
date, credit, debit, balance
2023-01-10, 1000.00, 0.00, 1000.00
2023-01-13, 2000.00, 0.00, 3000.00
2023-01-14, 0.00, 500.00, 2500.00
```

Importing this account should give the same statement as previously
