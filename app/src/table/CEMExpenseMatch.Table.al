table 6086349 "CEM Expense Match"
{
    Caption = 'Expense/Bank Trans. Match';

    fields
    {
        field(1; "Expense Entry No."; Integer)
        {
            Caption = 'Expense Entry No.';
            TableRelation = "CEM Expense";
        }
        field(2; "Transaction Entry No."; Integer)
        {
            Caption = 'Transaction Entry No.';
            TableRelation = "CEM Bank Transaction";
        }
        field(111; "Transaction Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Bank Transaction"."Bank-Currency Amount" where("Entry No." = field("Transaction Entry No.")));
            Caption = 'Transaction Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Expense Entry No.", "Transaction Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Entry No.")
        {
        }
    }
}