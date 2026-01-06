# Finance Domain CLAUDE.md

Place this in your `finance/` subdirectory. It loads when working in that directory.

## Context

Financial tracking, invoicing, expenses, and tax preparation.

## Task Project

```bash
# Finance tasks
task project:Finance list

# Common task types
task add project:Finance.Bills due:monday "Pay electricity"
task add project:Finance.Tax due:eom "Quarterly BAS"
task add project:Finance.Invoicing "Invoice ClientA for October"
```

## Key Dates

| Item | Frequency | Due |
|------|-----------|-----|
| BAS | Quarterly | 28th of month after quarter |
| Invoicing | Monthly | 1st of month |
| Bank reconciliation | Weekly | Friday |

## Email Filing

Finance emails go to:
- `Filing/Receipts/` - Purchase receipts
- `Filing/Invoices/` - Sent invoices
- `Filing/Tax/` - Tax correspondence
- `Vendors/[Name]/` - Vendor communications

## Sensitive Data

- No account numbers in notes
- Use references like "main business account"
- Receipts: forward to receipt-tracking app, then file
