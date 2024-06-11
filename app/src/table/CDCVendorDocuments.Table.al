table 6086013 "CDC Vendor Documents"
{
    Caption = 'Vendor Documents';

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Open Purchase Document,Posted Purchase Invoice,Posted Purchase Cr. Memo';
            OptionMembers = "Open Purchase Document","Posted Purchase Invoice","Posted Purchase Cr. Memo";
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document No.';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
        }
        field(5; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; "Latest Comment"; Text[250])
        {
            Caption = 'Latest Comment';
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(9; "Fully Applied"; Boolean)
        {
            Caption = 'Fully Applied';
        }
        field(10; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
    }

    keys
    {
        key(Key1; Type, "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure UpdateTable(VendorNo: Code[20])
    begin
    end;

    procedure GetLastAppvlComment(TableID: Integer; DocType: Integer; DocNo: Code[20]): Text[1024]
    begin
    end;

    procedure GetLastPostAppvlComment(TableID: Integer; DocNo: Code[20]): Text[1024]
    var
        PostApprvlCmtLine: Record "Posted Approval Comment Line";
    begin
        PostApprvlCmtLine.SetCurrentKey("Table ID", "Document No.");
        PostApprvlCmtLine.SetRange("Table ID", TableID);
        PostApprvlCmtLine.SetRange("Document No.", DocNo);
        if PostApprvlCmtLine.FindLast() then
            exit(PostApprvlCmtLine.Comment);
    end;


    procedure FindVendLedgEntry(VendorNo: Code[20]; DocType: Integer; DocNo: Code[20]; var VendLedgEntry: Record "Vendor Ledger Entry"): Boolean
    begin
        VendLedgEntry.SetCurrentKey("Document No.");
        VendLedgEntry.SetRange("Document No.", DocNo);
        VendLedgEntry.SetRange("Document Type", DocType);
        VendLedgEntry.SetRange("Vendor No.", VendorNo);
        exit(VendLedgEntry.FindFirst());
    end;
}

