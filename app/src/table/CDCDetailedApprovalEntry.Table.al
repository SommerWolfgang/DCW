table 6085744 "CDC Detailed Approval Entry"
{
    Caption = 'Detailed Approval Entry';
    Permissions = TableData "CDC Dtld. App. Entry Dimension" = rd;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Approval Group Code"; Code[10])
        {
            Caption = 'Approval Group Code';
            TableRelation = "CDC Approval Group".Code;
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(13; Approved; Boolean)
        {
            Caption = 'Approved';
        }
        field(14; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(20; "Entry Approved by User ID"; Code[50])
        {
            Caption = 'Entry Approved by User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Approval Group Code")
        {
        }
        key(Key3; "Table ID", "Document Type", "Document No.", "Approval Group Code", "User ID")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DtldAppvlEntryDim: Record "CDC Dtld. App. Entry Dimension";
    begin
        DtldAppvlEntryDim.SetRange("Table ID", "Table ID");
        DtldAppvlEntryDim.SetRange("Document Type", "Document Type");
        DtldAppvlEntryDim.SetRange("Document No.", "Document No.");
        DtldAppvlEntryDim.SetRange("Document Line No.", "Line No.");
        DtldAppvlEntryDim.DeleteAll;
    end;
}

