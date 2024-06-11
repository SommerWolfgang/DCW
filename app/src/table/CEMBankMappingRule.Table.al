table 6086350 "CEM Bank Mapping Rule"
{
    Caption = 'Bank Mapping Rule';

    fields
    {
        field(1; "Rule No."; Integer)
        {
            Caption = 'Rule No.';
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
        }
        field(10; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." WHERE(TableNo = CONST(6086330));
        }
        field(11; Value; Text[50])
        {
            Caption = 'Value';
        }
        field(12; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = CONST(6086330),
                                                        "No." = FIELD("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Expense Type Code"; Code[20])
        {
            Caption = 'Expense Type Code';
            TableRelation = "CEM Expense Type";
        }
    }

    keys
    {
        key(Key1; "Rule No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Oldrules: Record "CEM Bank Mapping Rule";
    begin
        if "Rule No." = 0 then
            if Oldrules.FindLast then
                "Rule No." := Oldrules."Rule No." + 10;
    end;


    procedure UseBankMappingRules(var Transaction: Record "CEM Bank Transaction")
    begin
        Transaction.TestField("Matched to Expense", false);

        if Transaction."Expense Type" = '' then begin
            SetRange("Continia User ID", Transaction."Continia User ID");
            if Rec.FindSet then
                repeat
                    UseBankMappingRule(Transaction);
                until (Rec.Next = 0) or (Transaction."Expense Type" <> '');

            if Transaction."Expense Type" = '' then begin
                SetRange("Continia User ID", '');
                if Rec.FindSet then
                    repeat
                        UseBankMappingRule(Transaction);
                    until (Rec.Next = 0) or (Transaction."Expense Type" <> '');
            end;
        end;
    end;

    local procedure UseBankMappingRule(var Transaction: Record "CEM Bank Transaction")
    var
        ExpenseType: Record "CEM Expense Type";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GetTable(Transaction);
        if "Field No." <> 0 then begin
            FieldRef := RecRef.Field("Field No.");
            if StrPos(UpperCase(Format(FieldRef.Value)), UpperCase(Value)) <> 0 then begin
                Transaction."Expense Type" := "Expense Type Code";
                if ExpenseType.Get("Expense Type Code") then
                    if ExpenseType."Exclude Transactions" then
                        Transaction."Exclude Entry" := ExpenseType."Exclude Transactions";
                Transaction.Modify;
            end;
        end;
    end;


    procedure LookupFieldNo(var Text: Text[1024]): Boolean
    var
        FieldRec: Record "Field";
    begin
        FieldRec.SetRange(TableNo, DATABASE::"CEM Bank Transaction");
        if FieldRec.Get(DATABASE::"CEM Bank Transaction", "Field No.") then;

        if PAGE.RunModal(PAGE::"Field List", FieldRec) = ACTION::LookupOK then begin
            Text := Format(FieldRec."No.");
            exit(true);
        end;
    end;
}

