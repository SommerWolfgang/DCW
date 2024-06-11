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
        field(100; "Expense Amount"; Decimal)
        {
            CalcFormula = Sum("CEM Expense".Amount WHERE("Entry No." = FIELD("Expense Entry No.")));
            Caption = 'Expense Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Transaction Amount"; Decimal)
        {
            CalcFormula = Sum("CEM Bank Transaction".Amount WHERE("Entry No." = FIELD("Transaction Entry No.")));
            Caption = 'Transaction Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Expense Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE("Entry No." = FIELD("Expense Entry No.")));
            Caption = 'Expense Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(111; "Transaction Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Bank Transaction"."Bank-Currency Amount" WHERE("Entry No." = FIELD("Transaction Entry No.")));
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Matching: Codeunit "CEM Expense Bank Trans. Mgt.";
    begin
        Matching.MarkMatchedExpense("Expense Entry No.", false);
        Matching.MarkMatchedBankTransaction("Transaction Entry No.", false);
    end;

    trigger OnInsert()
    var
        Matching: Codeunit "CEM Expense Bank Trans. Mgt.";
    begin
        Matching.MarkMatchedExpense("Expense Entry No.", true);
        Matching.MarkMatchedBankTransaction("Transaction Entry No.", true);
    end;
}

