using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class flight : MonoBehaviour
{
    Rigidbody rb;
    public float flightForce;
    horseBehaviour hB;
    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        hB = GetComponent<horseBehaviour>();
    }

    // Update is called once per frame
    void Update()
    {
        if(hB.beingRidden == true && hB.isTamed == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                rb.AddForce(Vector3.up * flightForce, ForceMode.VelocityChange);
            }
        }
    }
}
