table 6086335 "CEM Duplicate Exception"
{
    Caption = 'Duplicate Exception';
    DataCaptionFields = "Business Name";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Business Name"; Text[250])
        {
            Caption = 'Text';
        }
        field(20; "Maximum Amount(LCY)"; Decimal)
        {
            Caption = 'Maximum Amount(LCY)';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := NextEntryNo;
    end;

    var
        ConfirmDuplicate: Label 'Do you want to add %1 with %2 %3 as not duplicate in the future?';


    procedure MakeNotDuplicate(var BankTransaction: Record "CEM Bank Transaction Inbox")
    begin
        BankTransaction.TestField(Duplicate);
        BankTransaction.TestField("Business Name");
        if not Confirm(ConfirmDuplicate, false, BankTransaction."Business Name", FieldCaption("Maximum Amount(LCY)"),
           BankTransaction."Bank-Currency Amount")
        then
            Error('');

        BankTransaction.Duplicate := false;
        BankTransaction.Modify;

        SetFilter("Business Name", BankTransaction."Business Name");
        if FindFirst then begin
            if "Maximum Amount(LCY)" < BankTransaction."Bank-Currency Amount" then begin
                "Maximum Amount(LCY)" := BankTransaction."Bank-Currency Amount";
                Modify;
            end;
        end else begin
            "Business Name" := BankTransaction."Business Name";
            "Maximum Amount(LCY)" := BankTransaction."Bank-Currency Amount";
            Insert(true);
        end;
    end;

    local procedure NextEntryNo(): Integer
    var
        NotDuplicate: Record "CEM Duplicate Exception";
    begin
        if NotDuplicate.FindLast then;
        exit(NotDuplicate."Entry No." + 1);
    end;
}

