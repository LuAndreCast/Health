//
//  HealthManager.swift
//  HKTutorial
//

import Foundation
import HealthKit

class HealthManager
{
  let healthKitStore:HKHealthStore = HKHealthStore()
  
  let type_heartRate:HKQuantityType   = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
  let type_dob:HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!
  let type_bloodType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!
  
  let type_sex:HKObjectType = HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
  let type_height:HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
  let type_bodyMass:HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
  let type_workOut = HKObjectType.workoutType()
  
  
  
  func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
  {
    // 1. Set the types you want to read from HK Store
    let healthKitTypesToRead = Set( [type_heartRate, type_height, type_bodyMass, type_workOut, type_dob, type_sex, type_bloodType] )
    
  
    // 2. Set the types you want to write to HK Store
    let healthKitTypesToWrite = Set( [type_heartRate, type_height, type_bodyMass, type_workOut])
    
    // 3. If the store is not available (for instance, iPad) return an error and don't go on.
    if !HKHealthStore.isHealthDataAvailable()
    {
      let error = NSError(domain: "com.lc.HKTutorial", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
      if( completion != nil )
      {
        completion(success:false, error:error)
      }
      return;
    }
  
    // 4.  Request HealthKit authorization
    healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead)
    { (success, error) -> Void in
    
      if( completion != nil )
      {
        completion(success:success,error:error)
      }
    }
  }//eom
  
  
  func readProfile() -> ( age:Int?,  biologicalsex:HKBiologicalSexObject?, bloodtype:HKBloodTypeObject?)
  {
    var age:Int?
    var biologicalSex:HKBiologicalSexObject?
    var bloodType:HKBloodTypeObject?
    
    // 1. Request birthday and calculate age
    do
    {
    
      let birthDay = try healthKitStore.dateOfBirth()
      
      let today = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let differenceComponents = NSCalendar.currentCalendar().components(.Calendar, fromDate: birthDay, toDate: today, options: NSCalendarOptions(rawValue: 0) )
      age = differenceComponents.year
    }
    catch
    {
      print("Error reading Birthday: \(error)")
    }
    
    
    // 2. Read biological sex
    do
    {
      biologicalSex = try healthKitStore.biologicalSex()
    }
    catch
    {
      print("Error reading Biological Sex: \(error)")
    }
    
    do
    {
       bloodType = try healthKitStore.bloodType()
    }
    catch
    {
      print("Error reading Blood Type: \(error)")
    }
    
    
    // 4. Return the information read in a tuple
    return (age, biologicalSex, bloodType)
  }//eom
  
  
  func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!)
  {
    
    // 1. Build the Predicate
    let past = NSDate.distantPast() 
    let now   = NSDate()
    let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
    
    // 2. Build the sort descriptor to return the samples in descending order
    let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
    // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
    let limit = 1
    
    // 4. Build samples query
    let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
    { (sampleQuery, results, error ) -> Void in
      
      if error != nil {
        completion(nil,error)
        return;
      }
      
      // Get the first sample
      let mostRecentSample = results!.first as? HKQuantitySample
      
      // Execute the completion closure
      if completion != nil {
        completion(mostRecentSample,nil)
      }
    }
    // 5. Execute the Query
    self.healthKitStore.executeQuery(sampleQuery)
  }
  
  
  
  func saveBMISample(bmi:Double, date:NSDate ) {
    
    // 1. Create a BMI Sample
    let bmiType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)
    let bmiQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: bmi)
    let bmiSample = HKQuantitySample(type: bmiType!, quantity: bmiQuantity, startDate: date, endDate: date)
    
    // 2. Save the sample in the store
    healthKitStore.saveObject(bmiSample, withCompletion: { (success, error) -> Void in
      if( error != nil ) {
        print("Error saving BMI sample: \(error!.localizedDescription)")
      } else {
        print("BMI sample saved successfully!")
      }
    })
  }
  
}//eoc