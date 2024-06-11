table 6085742 "CDC Event Entry Comment"
{
    Caption = 'Event Entry Comment';
    Permissions = TableData "CDC Event Entry Comment" = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Event Entry No."; Integer)
        {
            Caption = 'Event Entry No.';
            TableRelation = "CDC Event Entry";
        }
        field(3; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,DC Document';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","DC Document ";
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Approver ID"; Code[50])
        {
            Caption = 'Approver ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Event Entry No.")
        {
        }
        key(Key3; "Document Type", "Document No.", "Approver ID", Date)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        EventEntryCmt: Record "CDC Event Entry Comment";
    begin
        EventEntryCmt.LockTable();
        if EventEntryCmt.FindLast() then
            "Entry No." := EventEntryCmt."Entry No." + 1
        else
            "Entry No." := 1;

        Date := Today;
    end;
}

