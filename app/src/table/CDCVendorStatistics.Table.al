table 6085781 "CDC Vendor Statistics"
{
    Caption = 'Vendor Statistics';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Sort; Integer)
        {
            Caption = 'Suggested Sorting';
        }
        field(10; "No. of Invoices"; Integer)
        {
            Caption = 'No. of Invoices';
        }
        field(11; "No. of Invoice Lines"; Integer)
        {
            Caption = 'No. of Invoice Lines';
        }
        field(12; "No. of Credit Memos"; Integer)
        {
            Caption = 'No. of Credit Memos';
        }
        field(13; "No. of Credit Memo Lines"; Integer)
        {
            Caption = 'No. of Credit Memo Lines';
        }
        field(14; "No. of OCR Pages"; Integer)
        {
            Caption = 'No. of OCR Pages';
        }
        field(20; "Suggested Format"; Option)
        {
            Caption = 'Suggested Format';
            OptionCaption = 'OCR,XML';
            OptionMembers = OCR,XML;
        }
        field(30; TempDateFilter; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Sort)
        {
        }
        key(Key3; "No. of Invoices", "No. of Invoice Lines", "No. of Credit Memos", "No. of Credit Memo Lines")
        {
        }
        key(Key4; "No. of Invoices", "No. of Invoice Lines", "No. of Credit Memos", "No. of Credit Memo Lines", "No. of OCR Pages")
        {
        }
        key(Key5; "No. of OCR Pages")
        {
        }
    }

    fieldgroups
    {
    }


    procedure GenerateVendorStatistics(VendorFilter: Text[1024]; DateFilter: Text[1024])
    var
        Vendor: Record Vendor;
        NoOfPoints: Integer;
        NoOfVendors: Integer;
        SuggestXmlPoints: Integer;
    begin
        DeleteAll;

        if VendorFilter <> '' then
            Vendor.SetFilter("No.", VendorFilter);

        if Vendor.FindSet then
            repeat
                Init;
                "No." := Vendor."No.";
                Name := CopyStr(Vendor.Name, 1, MaxStrLen(Name));

                CountPurchInv(Vendor."No.", DateFilter, "No. of Invoices", "No. of Invoice Lines");
                CountPurchCrMemo(Vendor."No.", DateFilter, "No. of Credit Memos", "No. of Credit Memo Lines");
                "No. of OCR Pages" := GetNoOfOCRPages(Vendor."No.", DateFilter);

                Sort := "No. of Invoice Lines" + "No. of Credit Memo Lines" + "No. of OCR Pages";

                if ("No. of Invoice Lines" + "No. of Credit Memo Lines" > 250) or ("No. of OCR Pages" > 50) then
                    "Suggested Format" := "Suggested Format"::XML;

                Insert;
            until Vendor.Next = 0;
    end;

    local procedure CountPurchInv(VendorNo: Code[20]; DateFilter: Text[1024]; var NoOfInv: Integer; var NoOfLines: Integer)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        // The Keys only exists in NAV 7.00.00 and forward
        if PurchaseHeader.SetCurrentKey("Document Type", "Pay-to Vendor No.") then;
        PurchaseHeader.SetRange("Pay-to Vendor No.", VendorNo);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);

        if PurchInvHeader.SetCurrentKey("Pay-to Vendor No.") then;
        PurchInvHeader.SetRange("Pay-to Vendor No.", VendorNo);

        if PurchaseLine.SetCurrentKey("Document Type", "Pay-to Vendor No.", "Currency Code") then;
        PurchaseLine.SetRange("Pay-to Vendor No.", VendorNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Invoice);

        PurchInvLine.SetRange("Pay-to Vendor No.", VendorNo);

        if DateFilter <> '' then begin
            PurchaseHeader.SetFilter("Document Date", DateFilter);
            if PurchaseHeader.FindSet then
                repeat
                    NoOfInv += 1;

                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    NoOfLines += PurchaseLine.Count;
                until PurchaseHeader.Next = 0;

            PurchInvHeader.SetFilter("Posting Date", DateFilter);
            NoOfInv += PurchInvHeader.Count;

            PurchInvLine.SetFilter("Posting Date", DateFilter);
            NoOfLines += PurchInvLine.Count;
        end else begin
            NoOfInv := PurchaseHeader.Count + PurchInvHeader.Count;
            NoOfLines := PurchaseLine.Count + PurchInvLine.Count;
        end;
    end;

    local procedure CountPurchCrMemo(VendorNo: Code[20]; DateFilter: Text[1024]; var NoOfCrMemo: Integer; var NoOfLines: Integer)
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        // The Keys only exists in NAV 7.00.00 and forward
        if PurchaseHeader.SetCurrentKey("Document Type", "Pay-to Vendor No.") then;
        PurchaseHeader.SetRange("Pay-to Vendor No.", VendorNo);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Credit Memo");

        if PurchCrMemoHdr.SetCurrentKey("Pay-to Vendor No.") then;
        PurchCrMemoHdr.SetRange("Pay-to Vendor No.", VendorNo);

        if PurchaseLine.SetCurrentKey("Document Type", "Pay-to Vendor No.", "Currency Code") then;
        PurchaseLine.SetRange("Pay-to Vendor No.", VendorNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Credit Memo");

        PurchCrMemoLine.SetRange("Pay-to Vendor No.", VendorNo);

        if DateFilter <> '' then begin
            PurchaseHeader.SetFilter("Document Date", DateFilter);
            if PurchaseHeader.FindSet then
                repeat
                    NoOfCrMemo += 1;

                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    NoOfLines += PurchaseLine.Count;
                until PurchaseHeader.Next = 0;

            PurchCrMemoHdr.SetFilter("Posting Date", DateFilter);
            NoOfCrMemo += PurchCrMemoHdr.Count;

            PurchCrMemoLine.SetFilter("Posting Date", DateFilter);
            NoOfLines += PurchCrMemoLine.Count;
        end else begin
            NoOfCrMemo := PurchaseHeader.Count + PurchCrMemoLine.Count;
            NoOfLines := PurchaseLine.Count + PurchCrMemoLine.Count;
        end;
    end;

    local procedure GetNoOfOCRPages(VendorNo: Code[20]; DateFilter: Text[1024]) NoOfRecords: Integer
    var
        Document: Record "CDC Document";
        DocCategory: Record "CDC Document Category";
        DocumentPage: Record "CDC Document Page";
    begin
        DocCategory.SetRange("Destination Header Table No.", DATABASE::"Purchase Header");
        DocCategory.SetRange("Source Table No.", DATABASE::Vendor);
        if DocCategory.FindSet then
            repeat
                Document.SetRange("Source Record No.", VendorNo);
                Document.SetRange("Document Category Code", DocCategory.Code);
                if DateFilter <> '' then
                    Document.SetFilter("Imported Date-Time", DateFilter);

                if Document.FindSet then
                    repeat
                        DocumentPage.SetRange("Document No.", Document."No.");
                        NoOfRecords += DocumentPage.Count;
                    until Document.Next = 0;
            until DocCategory.Next = 0;
    end;
}

