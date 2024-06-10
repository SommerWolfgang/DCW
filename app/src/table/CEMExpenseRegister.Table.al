table 6086372 "CEM Expense Register"
{
    Caption = 'Expense Register';
    LookupPageID = "CEM Expense Register";
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "No. of Expense Entries"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Register No." = FIELD("No.")));
            Caption = 'No. of Expense Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownExpenseEntries;
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = Count("CEM Expense" WHERE("Reimbursement Register No." = FIELD("No.")));
            Caption = 'No. of Reimbursed Expense Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownReimbEntries;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CreateRegEntry(): Integer
    var
        EMReg: Record "CEM Expense Register";
    begin
        EMReg.LockTable;
        if EMReg.FindLast then
            EMReg."No." := EMReg."No." + 1
        else
            EMReg."No." := 1;
        EMReg.Init;
        EMReg."Creation Date" := Today;
        EMReg."User ID" := UserId;
        EMReg.Insert;
        exit(EMReg."No.");
    end;


    procedure DrillDownExpenseEntries()
    var
        Expense: Record "CEM Expense";
        PostedExpense: Page "CEM Posted Expenses";
    begin
        Expense.SetCurrentKey("Register No.");
        Expense.SetRange("Register No.", "No.");
        PostedExpense.SetShowAllExpenseIncludingSttl;
        PostedExpense.SetTableView(Expense);
        PostedExpense.Run;
    end;


    procedure DrillDownReimbEntries()
    var
        Expense: Record "CEM Expense";
        PostedExpense: Page "CEM Posted Expenses";
    begin
        Expense.SetCurrentKey("Reimbursement Register No.");
        Expense.SetRange("Reimbursement Register No.", "No.");
        PostedExpense.SetShowAllExpenseIncludingSttl;
        PostedExpense.SetTableView(Expense);
        PostedExpense.Run;
    end;
}

