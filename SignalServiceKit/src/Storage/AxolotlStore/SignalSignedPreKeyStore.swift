//
// Copyright 2023 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import LibSignalClient

public protocol SignalSignedPreKeyStore: LibSignalClient.SignedPreKeyStore {

    func currentSignedPreKey(tx: DBReadTransaction) -> SignalServiceKit.SignedPreKeyRecord?
    func currentSignedPreKeyId(tx: DBReadTransaction) -> Int?

    func generateSignedPreKey(signedBy: ECKeyPair) -> SignalServiceKit.SignedPreKeyRecord
    func generateRandomSignedRecord() -> SignalServiceKit.SignedPreKeyRecord

    func storeSignedPreKey(
        _ signedPreKeyId: Int32,
        signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
        tx: DBWriteTransaction
    )

    func storeSignedPreKeyAsAcceptedAndCurrent(
           signedPreKeyId: Int32,
           signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
           tx: DBWriteTransaction
    )

    func cullSignedPreKeyRecords(tx: DBWriteTransaction)

    func removeSignedPreKey(
        _ signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
        tx: DBWriteTransaction
    )

    func setLastSuccessfulPreKeyRotationDate(_ date: Date, tx: DBWriteTransaction)
    func getLastSuccessfulPreKeyRotationDate(tx: DBReadTransaction) -> Date?

    // MARK: - Testing
#if TESTABLE_BUILD

    func removeAll(tx: DBWriteTransaction)

#endif
}

extension SSKSignedPreKeyStore: SignalSignedPreKeyStore {

    public func generateSignedPreKey(signedBy: ECKeyPair) -> SignalServiceKit.SignedPreKeyRecord {
        SSKSignedPreKeyStore.generateSignedPreKey(signedBy: signedBy)
    }

    public func currentSignedPreKey(tx: DBReadTransaction) -> SignalServiceKit.SignedPreKeyRecord? {
        currentSignedPreKey(with: SDSDB.shimOnlyBridge(tx))
    }

    public func currentSignedPreKeyId(tx: DBReadTransaction) -> Int? {
        currentSignedPrekeyId(with: SDSDB.shimOnlyBridge(tx))?.intValue
    }

    public func storeSignedPreKey(
        _ signedPreKeyId: Int32,
        signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
        tx: DBWriteTransaction
    ) {
        storeSignedPreKey(
            signedPreKeyId,
            signedPreKeyRecord: signedPreKeyRecord,
            transaction: SDSDB.shimOnlyBridge(tx)
        )
    }

    public func storeSignedPreKeyAsAcceptedAndCurrent(
        signedPreKeyId: Int32,
        signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
        tx: DBWriteTransaction
    ) {
        storeSignedPreKeyAsAcceptedAndCurrent(
            signedPreKeyId: signedPreKeyId,
            signedPreKeyRecord: signedPreKeyRecord,
            transaction: SDSDB.shimOnlyBridge(tx)
        )
    }

    public func cullSignedPreKeyRecords(tx: DBWriteTransaction) {
        cullSignedPreKeyRecords(transaction: SDSDB.shimOnlyBridge(tx))
    }

    public func removeSignedPreKey(
        _ signedPreKeyRecord: SignalServiceKit.SignedPreKeyRecord,
        tx: DBWriteTransaction
    ) {
        self.removeSignedPreKey(signedPreKeyRecord.id, transaction: SDSDB.shimOnlyBridge(tx))
    }

    public func setLastSuccessfulPreKeyRotationDate(_ date: Date, tx: DBWriteTransaction) {
        setLastSuccessfulPreKeyRotationDate(date, transaction: SDSDB.shimOnlyBridge(tx))
    }

    public func getLastSuccessfulPreKeyRotationDate(tx: DBReadTransaction) -> Date? {
        getLastSuccessfulPreKeyRotationDate(transaction: SDSDB.shimOnlyBridge(tx))
    }

    // MARK: - Testing

#if TESTABLE_BUILD

    public func removeAll(tx: DBWriteTransaction) {
        removeAll(SDSDB.shimOnlyBridge(tx))
    }

#endif
}
